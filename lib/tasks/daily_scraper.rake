namespace :daily_scraper do
  task :queue_it_up => :environment do

    retailers = Retailer.where(supported_for_sales: true).collect {|i| i.id}
    
    the_items = FullItem
      .where('last_scraped IS NULL OR last_scraped <= ?',
             (Time.now - 30.minutes))
      .where('retailer_id IN (?)', retailers)
      .order('last_scraped ASC')

    puts "qing up #{the_items.count} to scrape"

    the_items.all.each do |fi|
      FullItemScraper.perform_async(fi.id)
    end

  end

  task :tell_ben_its_working => :environment do
    SystemReportMailer.generic_system_notifier({
      :subject => "ShopOfMe Cron Jobs",
      :message => "At least they are running"}).deliver
  end

end
