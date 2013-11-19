class FullItemScraper
  include Sidekiq::Worker
  sidekiq_options :retry => false
  
  # scrape an item..
  def perform(id)

    # get the item
    item = FullItem.find(id)

    # scrape it
    item.scrape

    if !item.valid_item
      item.scrape_fail_count += 1
    else
      item.scrape_fail_count = 0
      item.scrape_success_count += 1
    end

    item.save
    puts "item: #{item.id} scraped"
  end
end
