namespace :housekeeping do

  # task to remove items from the database which have never been viewed
  # primarily to clean up after spidering. This is very destructive, 
  # backup first with admin_scripts/dump_prod_db
  desc "Deletes items from the database which have not been viewed"
  task :delete_unviewed_items => :environment do
    # get all of the items with no recorded likes associated with them
    items = FullItem.all.select {|item| (item.recorded_likes.count == 0)}

    # delete them all, use a transaction to avoid hammering the db
    ActiveRecord::Base.transaction do
      items.each {|item| item.delete}
    end
  end

  # if an item doesn't have an image or a price it should never have
  # been persisted. Q this up in sidekiq or something since it takes
  # forever to do this with callbacks.
  desc "q's up all items which are missing an image or a price for deletion"
  task "delete_invalid_items" => :environment do
    FullItem.where('image_path IS NULL OR selected_price IS NULL').each do |fi|
      FullItemDeletor.perform_async(fi.id)
    end
  end


  desc "sets default counts for all pre existing items"
  task "set_default_counts_on_items" => :environment do
    count_fields = %w(scrape_fail_count scrape_success_count)

    count_fields.each do |field|
      FullItem.where("#{field} IS NULL").each do |item|
        item[field] = 0
      end
    end
  end
end
