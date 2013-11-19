class Scrape
  @queue = :scraping

  def self.perform(item_id)
    
    item = FullItem.find(item_id)
    
    begin
      item.scrape
      if item.save
        puts "#{Time.now} item #{item.identifier} scraped from #{item.retailer.name} enabled is #{item.enabled}"
      else
        puts "#{Time.now} item #{item.identifier} scraping failed from #{item.retailer.name}"
      end
    rescue
      puts "#{Time.now} error occurred on item #{item_id} from retailer" 
    end

  end
end
