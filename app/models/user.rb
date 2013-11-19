class User < ActiveRecord::Base
	include FiltersItems
  has_many :visits
  belongs_to :invite
  recommends :full_items

  # recommendations are generate externally but for speed, they are cached here
  # for easy loading and querying.
  has_and_belongs_to_many :recorded_recommendations, :class_name => 'FullItem', :join_table => 'user_recs'

  has_and_belongs_to_many :alerted_full_items, :class_name => "FullItem", :join_table => 'alerted_full_items'
  has_many :sales_alerts
  
  # keep track of likes internally along with some meta data about the source
  # of the like and its date
  has_many :recorded_likes
  has_many :liked_items, :through => :recorded_likes, :source=> :full_item

	after_create :track_user_creation
	after_like :update_like_counts
  after_rec_generation :cache_recommendations

	validates_presence_of :identifier

	def to_s
		self.identifier
	end

  def cache_recommendations
    self.recommendations.each {|rec| self.recorded_recommendations << rec}
    self.migrated_to_new_scraper = true
    self.save
  end

  # returns the users cached recommendations with the filters applied
  # if options[:count] is set then returns that number of results, otherwise
  # returns 3. 
  # if options[:topup] is set to true then if the recommendations returned
  # is less then the number required these will be topped up with random
  # items with the filters applied.
  # use NOT IN to exclude any items which have already been sent based on the
  # list stored in Redis.
  def recs(filters, options={})
    # test command:
    # User.first.recs({categories: Category.all.map {|i| i.id} , gender: 'Male'},{reset: "true"})
    
    options[:count] = options[:count] || 30
    
    liked_ids = self.recorded_likes.collect {|rl| rl.full_item.id unless rl.full_item.nil?}
    liked_ids.delete_if {|i| i == nil}
    oldest_date = Time.now - 28.days
    the_recs = self.filter_items(self.recorded_recommendations.where("full_items.id NOT IN (?) AND (full_items.created_at >= ? OR last_visited >= ?)",liked_ids, oldest_date, oldest_date), filters, options, self.rec_key)


    if the_recs.count < options[:count]
      the_recs = the_recs +
        self.random_items(filters, {:count => (options[:count] - the_recs.count)})
    end

    the_recs
  end

  def random_items(filters, options={})
    options[:random] = "true"
    return self.filter_items(FullItem.order("id DESC"), filters, options, self.rec_key)
  end

  # return the key used for determining which recommendations the api has already
  # return returned since reset was last called, see recs for full explanation
  def rec_key
    Rails.env + ":sent_recs:" + self.id.to_s
  end

	def recommendations_with_filters(filters)
    Item.get_filtered_recommendations(filters[:gender],filters[:categories],self.recommendations)
	end

	
	# return the users recommendations with invalid entries (e.g. broken image)
	# links filtered out. This is computationally intensive as it will often process
	# records which are never displayed. 
	#
	# options{}
	# 	:count - the number of records to return
	# 	:displayed - the id's of the records which are already being displayed to the
	# 				 user. These should not be returned.
	def sanitised_records_with_filters(filters, options={})
		
		sanitised_records = []
		raw_recs = recommendations_with_filters filters
		count = options[:count] || raw_recs.length
		displayed = options[:displayed] || []

		# generate a key to keep track of the recommendations which have been sent in 
		# redis
		rec_key = Rails.env + ":sent_recs:" + self.id.to_s 

		# if reset is true then recommendations are being reloaded from scratch so remove
		# the redis set and start from the first returned item
		if options[:reset] == "true"
			$redis.del(rec_key)
		end


		raw_recs.each do |rec|
			# if the item is in the redis set of items already sent this session then don't
			# send it
			if !$redis.sismember(rec_key,rec.id)
				if rec.image_link && (rec.image_link.last != '/') && (sanitised_records.length < count) && (!self.likes?(rec)) && !self.dislikes?(rec) && !rec.image_link.index('loading_m.gif')
					sanitised_records << rec
					# track the item in the redis set otherwise it will be sent again next
					# time.
					$redis.sadd(rec_key, rec.id)
				end
			end
		end

		sanitised_records

	end

	def random_new_items(filters, options={})
		raw_other_items = Item.get_random_items(filters[:gender],filters[:categories])
		count = options[:count] ? options[:count] : 30
		random_items = []

		rec_key = Rails.env + ":sent_randoms:" + self.id.to_s 
		if options[:reset] == "true"
			$redis.del(rec_key)
		end

		raw_other_items.each do |rec|
			if !$redis.sismember(rec_key,rec.id)
				if rec.image_link && rec.image_link.last != '/' && !self.likes?(rec) && !self.ignored?(rec) && random_items.length < count && !rec.image_link.index('loading_m.gif')
					$redis.sadd(rec_key, rec.id)
					random_items << rec
				end
			end
		end

		random_items

	end

	def track_user_creation
		Analytics::NewInstall.new.track
		self.score = 1
		self.save
	end

	def increment_score
    if self.score.nil? 
      self.score = 1
    else
      self.score = self.score + 1
    end
	end

	# maintain internal redis lists of item likes and there scores.
	# do this for today, the current week, the current month and all
	# time.
	def update_like_counts(item)
		base_key = Rails.env + ":top_items:"

		all_key = base_key + 'all_time'
		today_key = base_key + 'daily:' +  Date.today.to_s
		this_week_key = base_key + 'weekly:' +  Date.today.year.to_s + ':' + Date.today.cweek.to_s
		this_month_key = base_key + 'monthly:' +  Date.today.year.to_s + ':' + Date.today.month.to_s

		[all_key,today_key,this_week_key,this_month_key].each do |key|
			$redis.zincrby key, 1, item.id
		end
	end

	# record a visit by the current user
	def visit_site(url)
		
		result = {:new_item => false, :valid_item => false, :valid_site => false}

    # store the visit in question
    self.visits << Visit.new({:site => url})
    
    the_item = Retailer.find_or_add_item(url)
    the_item.last_visited = DateTime.now

    if the_item && the_item.new_record?
      result[:new_item] = true
    end

    if the_item && the_item.persisted? && the_item.created_at > (Time.now - 5.seconds)
      result[:new_item] = true
    end

    # if not then it's probably a category page or similar 
    if the_item && the_item.valid_item
      # only save the item if it is valid otherwise the DB will fill
      # up with category pages and the like
      if result[:new_item] 
        the_item.save
      end
      self.like the_item, {source: :extension}
      result[:valid_item] = true
      result[:valid_site] = true

      # users get a point every time they like something new via
      # the extension so increment score.
      if self.score.nil? 
        self.score = 1
      else
        self.score += 1
      end
    end

		result

	end

	# Begin user focussed analytics operations. 

	# returns the distribution of the number of supported domains
	# visited by each user. 
	def self.supported_domains_visited_histogram
		distribution = {}
		User.all.each do |user|supported_domains_visited_histogram
			domains_visited = user.liked.collect {|like| like.supported_domain}.uniq.count
			if distribution[domains_visited]
				distribution[domains_visited] += 1
			else
				distribution[domains_visited] = 1
			end
		end
		distribution
	end

  # returns the nuber of different supported domains the user has visited
  def number_of_retailers_visited(period=30)
    self.recorded_likes.where('created_at > ?', Date.today-period.days).collect {|rl| rl.full_item.retailer.id unless rl.full_item.nil?}.uniq.count
  end

  # use custom like, dislike methods rather than the recommendable ones
  # so that we are not dependant on recommendable for structure
  #
  def like(item, options={})
    #self.rr_like item
    the_date = options[:date] || Time.now
    the_like = RecordedLike.new({full_item: item, source: options[:source], recorded_date: the_date})
    self.recorded_likes << the_like
    the_like.save
  end

  def dislike(item, options={})
    self.rr_dislike item
  end

  def location(force_update=false)
    if self.last_ip_country.nil? || force_update
      begin
        self.last_ip_country = self.last_ip ? Geocoder.search(self.last_ip)[0].data["country_name"] : nil
      rescue Exception
      end 
      self.save
    end
    self.last_ip_country
  end

  def generate_sales_alert
    sales_alert = self.sales_alerts.create
    liked_itmes = self.liked_items.where("full_items.created_at >= ? and full_items.on_sale = ?", 200.days.ago, true)
    if !liked_itmes.empty?
      liked_itmes.each do |liked_item|
        unless AlertedFullItem.exists?(:user_id => self.id, :full_item_id => liked_item.id)
          AlertedFullItem.create(:user_id => self.id, :full_item_id => liked_item.id)
          FullItemsSalesAlert.create(:sales_alert_id => sales_alert.id, :full_item_id => liked_item.id)
        end
      end
    end
  end
end