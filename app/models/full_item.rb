class FullItem < ActiveRecord::Base
  belongs_to :retailer

  # colours and categories are specific to retailers as terminology
  # tends to differ from retailer to retailer
  has_many :categories_full_items, dependent: :destroy
  has_many :categories, through: :categories_full_items
  has_many :master_categories, through: :categories
  has_many :recorded_likes, dependent: :destroy


  has_and_belongs_to_many :retailer_colours, uniq: true
  has_many :master_colours, through: :retailer_colours

  # Every time an item is scraped, as well as updating the current fields
  # the item is added to versions so that trends over time can be analysed
  has_many :full_item_histories, dependent: :destroy

  #acts_as_recommendable

  attr_accessor :doc, :valid_item, :just_created

  # call the scraping methods sequentially, return self
  def scrape(options={})

    if self.identifier = self.get_identifier
      # only load the document from the items url if doc has not already
      # been set, this allows a stored version of doc (e.g. from history
      # database to be provided
      
      # need to know if the item was on sale so can flag
      # when something goes on sale.
      was_on_sale = self.on_sale
      self.load_document
      self.valid_item = true
      # perform the actual scraping
      self.scrape_image_link
      self.scrape_price
      self.scrape_categories
      self.scrape_colours

      # decide whether we have enough information item or not. If not then mark
      # the item as disabled, otherwise mark it as enabled.
      if self.selected_price && self.image_path
        self.enabled = true
      else
        self.enabled = false
      end
    else
      # this is used so that the caller can decide whether or not to  the item
      # generally if this is false the caller would be expected not to save the item
      # and add the url to a "not item" list to avoid future calls.
      self.valid_item = false
      self.enabled = false
    end

    # if there's no image link, this item can't be displayed and it should be assumed
    # is not a valid item.
    if !self.image_path
      self.valid_item = false
      self.enabled = false
    end

    # take a copy of self and add to self.versions
    this_version = FullItemHistory.new({
      normal_price: self.normal_price,
      sale_price: self.sale_price,
      original_price: self.sale_original_price,
      enabled: self.enabled,
      valid_item: self.valid_item,
      selected_price: self.selected_price
    });

    self.last_scraped = Time.now
    self.full_item_histories << this_version
    self.just_created = true unless self.id
    self.update_cache

    # must have a gender as this is the basic filter applied to everything
    # in the front end.
    if self.gender == "" || self.gender.nil?
      self.enabled = false
    end

    # we know the item has gone on sale so queue it up as now
    # on sale
    if (!was_on_sale) && self.on_sale
      puts "Gone on sale baby"
      OnSaleItem.create(full_item: self) if self.id
    end

    return self
  end

  # checks the url to see if this could be an item from the retailer,
  # if so returns the identifier otherwise returns false
  def get_identifier
     # if we're using a param for an identifier then get this param
      if self.retailer.param_based
        param_hash = Rack::Utils.parse_query URI(self.link).query
        return param_hash[self.retailer.param_name]
      else
        return self.link.split('?')[0]
      end
  end

  # loads the document from the url into self.doc
  def load_document
    require 'open-uri'
    self.doc = Nokogiri::HTML(open(self.link))
  end

  # extract the image_link from doc
  # return true if succesful, false otherwise
  def scrape_image_link
    # extract the images which match the selector, for now assume the main
    # image is always the first one.
    the_images = self.doc.css(self.retailer.image_selector)
		unless (the_images.nil? ||the_images.empty?)
			raw_image_link = the_images.first.attribute('src').to_s 
			
      #correct for relative image paths
      if raw_image_link[0] == '/' && raw_image_link[1] != '/'
				self.image_path = 'http://' + self.retailer.domain + raw_image_link

      #some domains (e.g. H&M) return images which start with // which causes
      #problems for rails asset pipeline (sometimes). Add http: to this to form
      #a valid external url
      elsif raw_image_link[0] == '/' && raw_image_link[1] == '/'
        self.image_path = 'http:' + raw_image_link
      else
				self.image_path = the_images.first.attribute('src').to_s 
      end
      return true
    else
      return false
		end
  end

  # extract price data and assign self.selected price  and self.on_sale based on 
  # whether the item is on sale or not
  def scrape_price
    # get the prices
    self.normal_price = self.scrape_single_price(:normal)
    self.sale_price = self.scrape_single_price(:sale)
    if self.retailer.sale_original_price
      self.sale_original_price = self.scrape_single_price(:sale_original_price)
    end


    # as long as we have a sale price or a normal price we can determine the
    # current price of the item.
    if self.normal_price || self.sale_price
      # set the items current price
      self.selected_price = self.sale_price || self.normal_price

      # if there is a sale price then flag the item as on sale for easy searching
      if self.sale_price && self.sale_price > 0
        self.on_sale = true
      else
        self.on_sale = false
      end

      # only scrape an original price if the item is on sale
      if self.on_sale
        self.sale_original_price = self.sale_original_price || self.normal_price
      end

    else
      return false
    end
  end

  # scrape a single price using selectors and method determined by type, 
  # valid values for type:
  # - :normal
  # - :sale
  # - :sale_original_price
  #
  def scrape_single_price(type)
    # start of treating price as a string so unwanted chars can be removed
    # before converting to a float
    price = nil

    # if the price is just a single CSS element
    if self.retailer.send("#{type}_simple_price")
      doc.css(self.retailer.send("#{type}_simple_price_selector"))
      price = doc.css(self.retailer.send("#{type}_simple_price_selector"))
      unless price.first.nil?
        price = price.first.content
      else
        price = nil
      end
    elsif self.retailer.send("#{type}_composite_price")
      price_selectors = self.retailer.send("#{type}_composite_price_selectors").split(',')
      price_selector_indexes = self.retailer.send("#{type}composite_price_indexes").split(',')
      price_selectors.each_with_index do |ps,index|
        price += doc.css(ps)[price_selector_indexes[index].to_i].content
      end
    end

    if price && (price != "")
      price = parse_price_string(price, self.retailer.to_remove_from_normal_price)
      if price && price > 0
        return price
      else
        return nil
      end
    end
  end

  # extract any extra text from the extracted price string to allow it to be converted
  # to a flaot, return the price as a flaot
  def parse_price_string(price,to_remove)
    generic_to_remove = Setting.where('key = ?','remove_text_from_all_prices').first.value
    # if we have generic things to remove from all prices in the settings table
    # then add these to the array of things to remove
    if generic_to_remove
      generic_to_remove = generic_to_remove.split('|')
      to_remove = to_remove + generic_to_remove
    end

    # iterate over price and remove all matches
    to_remove.each do |r|
      price = price.gsub(r,'')
    end

    return price.to_f
  end


  # extract the categories, check if this retailer already has the relevant
  # categories, if they do then add these categories to the current model
  # otherwise create new unsaved entries and add them
  def scrape_categories
    cats = []
    # sometimes multiple selectors are used for categories so iterate through 
    # each one assuming commas as a separator
    self.retailer.category_selector.split('|').each do |selector|
      the_categories = doc.css(selector)
      the_categories.each do |cat|
        # find an existing category if it exists or initialise a new one if not
        # con't create it otherwise we will end up with dud entries when running
        # tests. New retailer categories shouldn't be saved until the item is saved
        linked_cat = Category.find_or_initialize_by_name(cat.content)
        # only add the category if it isn't already there
        (self.categories << linked_cat) unless self.categories.include? linked_cat
      end
    end
  end

  # extract the colours, operation generally the same as for categories
  def scrape_colours

  end

  # set the gender of the item based on categories to allow for gender queries without
  # joins
  def set_gender

  end

  # update fields which just caches of particular properties to speed up querying. E.g.
  # the gender field allows for very quick gender based queries rather than joining
  # with the categories table every time.
  def update_cache
    #male = !self.master_categories.where(name: 'Men').empty?
    #female = !self.master_categories.where(name: 'Women').empty?

    # don't use a WHERE on master_categories for this beacuse that requires the model
    # to be saved which means dm previews will create new retailers and items every
    # time.
    male = false
    female = false
    self.categories.each do |cat|
      
      if cat.master_category
        if cat.master_category.name == 'Men'
          male = true
        elsif cat.master_category.name == 'Women'
          female = true
        end
      end
    end

    if self.retailer.always_female
      female = true
      male = false
    elsif self.retailer.always_male
      female = false
      male = true
    end

    if male
      self.gender = "Male"
    elsif female
      self.gender = "Female"
    else
      self.gender = ""
    end
  end

  # begin legacy methods to allow FullItem to support api v1
  
  def the_retailer
		self.retailer unless self.retailer.nil?
  end

  def the_price
    self.selected_price
  end

  def url
    self.link
  end

  def affiliate_link
    main_link = self.link
		"http://go.redirectingat.com/?id=33405X954819&xs=1&url=" + CGI::escape(main_link) 
  end

  def all_master_categories
		the_categories = self.master_categories.collect {|mc| mc.id}.uniq.join(',')
  end

  def title
    ""
  end

  # begin methods for analysing retailers data quality
  
  # returns a score indicating level of data issues, 0 being
  # perfect data. At the moment just returns the number of disabled
  # items
  def data_score
    self.full_items.where(enabled: false).count
  end

  # compares the last two entries in the items history and returns
  # true if the price has gone down
  def price_has_gone_down
    if self.full_item_histories.count >= 2
      most_recent = self.full_item_histories[-1]
      previous = self.full_item_histories[-2]
      
      # now the actual logic
    end
  end

end
