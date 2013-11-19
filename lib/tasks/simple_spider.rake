namespace :simple_spider do
  task :site , [:site] =>:environment do |t,args|
    domain = args[:site]
    puts "scraping site: #{domain}"
    the_domain = domain
    count = 0
    open("scrapes/#{the_domain}.txt", 'a') do |f|
      Anemone.crawl("http://#{the_domain}") do |anemone|
        anemone.storage = Anemone::Storage.SQLite3 "scrapes/dbs/#{the_domain}.sqlite3"
        anemone.on_every_page do |page|
          f.puts page.url
          count += 1
          puts "#{domain} urls processed: #{count}"
        end
      end
    end
  end

  task :import_from_file, [:filename] => :environment do |t,args|
    filename = args[:filename]
    items = 0
    errors = 0
    blacklist = 0
    File.open("urls_for_import/#{filename}", "r") do |file_handle|
      file_handle.each do |url|
        # don't try and reprocess blacklisted urles
        begin
          if BlacklistedUrl.where(url: url).count == 0
            #get an item object for the url
            item =  Retailer.find_or_add_item(url)
            #new item?
            if item.just_created
              #new valid item?
              if item.valid_item
                # it's valid, save it
                item.save
                items += 1
                puts "got an item: #{url} total so far: #{items}"
              else
                # it's not, blacklist it
                bl = BlacklistedUrl.new({url: url})
                bl.save
                blacklist += 1
                puts "blacklisted an item: #{url} total so far: #{blacklist}"
              end
            else
              puts "item already exists #{url}"
            end
          else
            puts "this was blacklisted #{url}"
          end
        rescue
          errors += 1
          puts "error on: #{url} total: #{errors}"
        end
      end
    end
  end
end
