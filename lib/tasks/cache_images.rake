namespace :item_scraping do
  desc "Attempts to download item images and cache them as base64 strings"
  task :cache_images => :environment do
    Item.all.each do |item|
    	puts "Trying to download image for item: " + item.id.to_s
    	if item.refresh_cached_image && item.save
    		puts "Downloaded image For item: " + item.id.to_s + " and saved"
    	end
    end
  end
end