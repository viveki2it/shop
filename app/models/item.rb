# coding: utf-8
class Item < ActiveRecord::Base
	belongs_to :supported_domain
	has_many :items_categories
	has_many :categories, :through => :items_categories, :uniq => true

  has_many :recorded_likes


	#use: Item.joins(:master_categories).where("master_categories.name IN 
    #     (?)",['cat1','cat2']) for all items matching particular mater cats

	#the below provides checks for groups of categories e.g. gender and category
	#Item.joins(:master_categories).where("(master_categories.name IN (?)) 
		#AND (master_categories.name IN(?))",['Men','Jeans'],['Bla'])

	has_many :master_categories, :through => :categories

	before_save :extract_data

	def self.get_filtered_recommendations(gender,categories,items) 

		gender_user_filtered = Item.joins(:master_categories).where("(master_categories.name IN (?)) AND (items.id IN (?))",gender,items).select('items.id').group('items.id').all.map {|i| i.id}

		

		Item.joins(:master_categories).joins(:supported_domain).where("(master_categories.name IN (?)) AND (items.id IN (?)) AND ((supported_domains.dont_display <> true) OR (supported_domains.dont_display IS NULL))",categories,gender_user_filtered).select('items.id, items.image_link,items.url ,items.title, base64_image, supported_domains.domain, items.price').group('items.id, items.image_link,items.url ,items.title, base64_image, supported_domains.domain, items.price')

	end

	def self.get_random_items(gender, categories)

		gender_filtered = Item.joins(:master_categories).where("(master_categories.name IN (?))",gender).select('items.id').group('items.id').all.map {|i| i.id}

		if categories.include? 'All'
			query = Item.joins(:master_categories).joins(:supported_domain).where("items.id IN (?)" , gender_filtered)
		else
			query = Item.joins(:master_categories).joins(:supported_domain).where("(master_categories.name IN (?)) AND (items.id IN (?)) AND ((supported_domains.dont_display <> true) OR (supported_domains.dont_display IS NULL))",categories,gender_filtered)
		end

		query.select('items.id, items.image_link,items.url ,items.title, base64_image, supported_domains.domain, items.price').group('items.id, items.image_link,items.url ,items.title, base64_image, supported_domains.domain, items.price').order('random()').limit(90)

	end

	# returns a skimlink affilaite link for this item
	def affiliate_link 
		# http://go.redirectingat.com/?id=123X456&url=http%3A%2F%2Famazon.com%2F
		# the raw retailer link
		main_link = self.url
		"http://go.redirectingat.com/?id=33405X954819&xs=1&url=" + CGI::escape(main_link) 
	end

	def gender
		the_gender = self.master_categories.where("master_categories.name IN (?)", ['Men','Women'])
		if the_gender.empty?
			''
		else
			the_gender.first.name
		end
	end

	def the_price
		# price = (Random.new().rand*100).round
		# (price = price - 10) unless price <= 10
		self.price || 0
	end

	def the_retailer
		self.domain unless self.domain.nil?
	end

	def the_domain
		self.supported_domain.domain unless self.supported_domain.nil?
	end

	def all_master_categories
		the_categories = self.master_categories.collect {|mc| mc.id}.uniq.join(',')
	end

  def master_categories_array
    self.master_categories.uniq.collect {|mc| mc.name}
  end

	def refresh_cached_image
		require 'open-uri'
		begin
			doc = Nokogiri::HTML(open(self.url))
			the_images = doc.css(self.supported_domain.selector)
			# try and download a copy of the image and store it as a base64 string in the 
			# database so that we can return it as part of the JSON.
			begin
				self.base64_image = ActiveSupport::Base64.encode64(open(self.image_link.to_s) { |io| io.read }) 
			rescue
				puts "failed to download image" 
				return false
			end
		rescue
  			puts "404 Error thrown accessing: " + self.url
  			return false
		end 
		true
	end

	def refresh_price
		require 'open-uri'
		price = ""
		begin
			doc = Nokogiri::HTML(open(self.url))
			the_images = doc.css(self.supported_domain.selector)
			# try and download a copy of the image and store it as a base64 string in the 
			# database so that we can return it as part of the JSON.
			begin
				price = self.extract_price(doc)
			rescue
				puts "failed to get price" 
				return false
			end
		rescue
   			puts "Error getting price from url: " + self.url
		end 
		price
	end

	def extract_data 
		require 'open-uri'
		begin
			doc = Nokogiri::HTML(open(self.url))
			extract_image doc
			extract_categories doc
      extract_price doc
		rescue
  			logger.debug "404 Error thrown accessing: " + self.url
		end 
	end

	def extract_image(doc)
		the_images = doc.css(self.supported_domain.selector)
		unless (the_images.nil? ||the_images.empty?)
			raw_image_link = the_images.first.attribute('src').to_s 
			if raw_image_link[0] == '/' and raw_image_link[1] != '/'
				self.image_link = 'http://' + self.supported_domain.domain + raw_image_link
			else
				self.image_link = the_images.first.attribute('src').to_s 
			end
		end
	end

	def extract_categories(doc)
		unless self.supported_domain.category_selector.nil?
			self.categories.clear
			the_categories = doc.css(self.supported_domain.category_selector)
			the_categories.each do |cat| 
				the_category = Category.find_or_create_by_name cat.content
				self.categories << the_category
			end
		end
	end

	def extract_price(doc)
		unless self.supported_domain.no_price
			price = ""
			if self.supported_domain.use_simple_price_selector
				doc.css(self.supported_domain.simple_price_selector)
				price = doc.css(self.supported_domain.simple_price_selector).first.content
			elsif self.supported_domain.use_composite_price_selector
				price_selectors = self.supported_domain.composite_price_selector.split(',')
				price_selector_indexes = self.supported_domain.composite_price_selector_index.split(',')
				price_selectors.each_with_index do |ps,index|
					price += doc.css(ps)[price_selector_indexes[index].to_i].content
				end
			end

			if price == ""
				price = nil
			else
				price = price.gsub('£','').gsub('GBP','').gsub('Price:','').gsub(/^\p{Space}+|\p{Space}+$/, '').gsub('Â','').gsub(',','')
				price = price.to_f
			end

			self.price = price
		end
	end

	def get_related_items
		require 'open-uri'
		doc = Nokogiri::HTML(open(self.url))
		title = CGI::escape(doc.css('title').first.content)

		result = JSON.parse(open('https://api.svpply.com/v1/products/search.json?query=' + title).read)
	end
end
