namespace :migrate_to_scraper do
  task :retailers => :environment do
    SupportedDomain.all.each do |sd|
      # if there isn't already a retailer for this domain in the database
      # then it needs importing
      if Retailer.find_by_domain(sd.domain).nil?
        new_retailer = Retailer.new({
          name: sd.domain,
          domain: sd.domain,
          enabled: !sd.dont_display,
          index_based: sd.index_based,
          index: sd.index,
          param_based: sd.param_based,
          param_name: sd.param_key,
          url_based: (!sd.index_based && !sd.param_based),
          image_selector: sd.selector,
          normal_simple_price: sd.use_simple_price_selector,
          normal_simple_price_selector: sd.simple_price_selector,
          normal_composite_price_selectors: sd.composite_price_selector,
          normal_composite_price_indexes: sd.composite_price_selector_index,
          category_selector: sd.category_selector
        })
        if new_retailer.save
          puts "migrated #{new_retailer.name}"
        else
          puts "failed to migrate #{new_retailer.name}"
        end
      end
    end
  end

  task :items => :environment do
    Item.all.reverse.each do |item|
      begin
        if BlacklistedUrl.where(url: item.url).count == 0
          original_url = item.url
          item = Retailer.find_or_add_item(item.url)
          if item.id.nil?
            if item.valid_item
              if item.save
                puts "added full item #{item.identifier} from retailer #{item.retailer.name} with status enabled as #{item.enabled}"
              else
                puts "item from retailer #{item.retailer.name} failed"
              end
            else
              puts "skipped item #{item.identifier} from retailer #{item.retailer.name} because it doesn't look like an item"
              bl = BlacklistedUrl.new({url: original_url})
              bl.save
            end
          end
        end
      rescue
        puts "error encountered on item with url: #{item.url}, continuing"
      end
    end
  end

  # used for migrating all of the users likes of the item class to
  # the full_item class also creates 
  task :likes => :environment do
    User.all.each do |user|
      old_likes = user.liked
      user.recorded_likes.delete_all
      old_likes.each do |like|
        if like.kind_of? Item
          the_item = Retailer.find_or_add_item(like.url, {do_not_scrape: false})
        end
        if the_item
          the_item.save
          user.like the_item
          puts "liked item #{the_item.id} from user #{user.id}"
          recorded_like = RecordedLike.new({full_item: the_item,
                                            user: user,
                                            source: 'legacy',
                                            recorded_date: like.created_at
                                            })
          recorded_like.save
        end
        user.unlike like
      end
      user.save
    end
  end

  # used for migrating all of the users likes of the item class to
  # the full_item class also creates 
  task :dislikes => :environment do
    User.all.each do |user|
      old_likes = user.disliked
      user.recorded_likes.delete_all
      old_likes.each do |like|
        if like.kind_of? Item
          the_item = Retailer.find_or_add_item(like.url, {do_not_scrape: true})
        end
        if the_item
          the_item.save
          user.dislike the_item
          puts "disliked item #{the_item.id} from user #{user.id}"
          recorded_like = RecordedLike.new({full_item: the_item,
                                            user: user,
                                            source: 'legacy',
                                            recorded_date: like.created_at
                                            })
          recorded_like.save
        end
        user.undislike like
      end
      user.save
    end
  end

  task :mark_as_not_migrated => :environment do
    User.all.each do |user|
      user.migrated_to_new_scraper = false
      user.save
    end
  end

  task :delete_all_categories => :environment do
    CategoriesFullItem.delete_all
  end

  task :regen_recs => :environment do 
    User.where(:migrated_to_new_scraper => false).each do |user|
      #puts "recommendations about to be updated for user #{user.id}"
      #user.send :update_similarities
      #user.send :update_recommendations
      #user.migrated_to_new_scraper = true
      #user.save
      Recommendable.enqueue(user.id)
      puts "recommendations queued #{user.id}"
    end
  end

  task :regen_likes => :environment do
    User.all.each do |user|
      user.visits.each do |visit|
        begin
          item = Retailer.find_or_add_item(visit.site, {do_not_scrape: true})
          unless item.nil?
            user.like(item, {date: visit.created_at})
            user.save
            puts "liked item #{item.url} by user #{user.id}"
          end
        rescue
        end
      end
    end
  end

  task :cache_gender => :environment do
    FullItem.all.each do |item|
      begin
        item.update_cache
        if (item.gender != "") && (item.selected_price) && (item.image_path)
          item.enabled = true
        end
        item.save
        puts "cached gender #{item.gender} for item #{item.id}"
      rescue
      end
    end
  end

end
