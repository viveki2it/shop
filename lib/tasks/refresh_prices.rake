namespace :item_scraping do
  task :refresh_prices , [:supported_domain_id] => :environment do |t,args|
  	
    # set up vars for reporting stats
    items_processed = 0
    items_succesful = 0
    items_failed = 0
    start_time = Time.now
    failed_items = []

    # if there is a supported domain specified then only update prices for it
    if args[:supported_domain_id]
      puts "looking for items from retailer with id : " + args[:supported_domain_id]
      the_retailers = SupportedDomain.find_all_by_id(args[:supported_domain_id].to_i)
    # if there's no supported domain then update prices for all
    else
      puts "looking for items from all retailers"
      the_retailers = SupportedDomain.all
    end
  	
    # check we have some retailers
    if !the_retailers.empty?
      the_retailers.each do |the_retailer|
    		puts "found retailer: " + the_retailer.domain
    		
        # check the retailer has price selectors set up
        if the_retailer.use_simple_price_selector || the_retailer.use_composite_price_selector
          
          # go through the retailers items, updating the price
          the_retailer.items.where('image_link IS NOT NULL').each do |item|
      			items_processed += 1
            failed = false
            
            if item.refresh_price
      				
              if item.save 
      					puts "got price (#{item.price}) and saved"
                items_succesful += 1
      				else
      					puts "got price (#{item.price}) but save failed"
                items_failed += 1
      				end

      			else
      				puts "couldn't get price"
              failed = true
              items_failed += 1
      			end
            if item.price == nil || item.price <= 0 || failed == true
              puts "logging a failed item"
              failed_items << "#{item.supported_domain.domain},#{item.url}"
            end
      		end
        else
          puts "no price selectors setup for this retailer"
        end
      end
  	else
  		puts "No retailer found, exiting"
  	end

    

    # send a report
    SystemReportMailer.generic_system_notifier({
      :subject => "ShopOfMe Price Refresh",
      :message => "
        <h2>Overview</h2>
        <p>Price refresh started at #{start_time.to_s}</p>
        <p>Total Items in DB: #{Item.all.count}</p>
        <p>Total Items with valid image link in DB: #{Item.where("image_link IS NOT NULL").count.to_s}</p>
        <p>Total items with a price above zero: #{Item.where("price > 0").count.to_s}</p>
        <h2>This Run</h2>
        <p>Items Processed: #{items_processed.to_s}</p>
        <p>Prices extracted successfully: #{items_succesful.to_s}</p>
        <p>Price extraction failed: #{items_failed.to_s}</p>
        <p>Run Time: #{(Time.now - start_time).to_s} seconds</p> 
        <h2>Failures:</h2>
        #{failed_items.join('<br/>')}
        " 
    }).deliver
  end
end