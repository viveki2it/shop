class Retailer < ActiveRecord::Base
  has_many :full_items
  has_many :retailer_categories
  has_many :retailer_colours
  has_many :scrape_records

  # attempts to find an item based on the url, if so returns the item
  # if it cannot find an item but the retailer is supported then it attempts
  # to extract data from the item and create a new item for that retailer from
  # it.
  #
  # @return - the item or false
  #
  def self.find_or_add_item(url, options={})
    the_host_name = URI(url).host
    the_retailer = Retailer.find_by_domain(the_host_name)
    # find an item based on a url parameter
    if the_retailer && the_retailer.param_based
      # extract the parameters from the URL
			param_hash = Rack::Utils.parse_query URI(url).query

      # extract the parameter used to identify the item, this is the identifier
      the_item_identifier = param_hash[the_retailer.param_name]

    # find items using the entire url as they key, this is generally the
    # fallback option
    elsif the_retailer && the_retailer.url_based
      the_item_identifier = url
    end

    # find the item based on the identifer found, it doesn't matter what
    # sort of identifer it is, finding an item is always just a text comparison
    # on the identifier field.
    if the_retailer
      the_item = the_retailer.full_items.find_by_identifier(the_item_identifier)
    end

    # if there is an item, return it, otherwise try and scrape it
    if the_item
      return the_item
    elsif !options[:do_not_scrape]
      return Retailer.scrape(url, the_retailer, options)
    end
  end

  # attempt to scrape the provided item as an entry from the provided retailer
  # return the item if succesful and nil otherwise
  def self.scrape(url, retailer, options={})
    the_item = FullItem.new({retailer: retailer, link: url})
    if the_item.scrape
      return the_item
    else
      return nil
    end
  end

  def to_remove_from_sale_price
    if self.sale_remove_from_price
      self.sale_remove_from_price.split('|')
    else
      []
    end
  end

  def to_remove_from_normal_price
    if self.normal_remove_from_price
      self.normal_remove_from_price.split('|')
    else
      []
    end
  end

end
