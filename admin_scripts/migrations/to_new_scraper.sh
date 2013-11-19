#!/bin/bash
cd ../..
# MANUAL: upgrade the linode to a linode1536
# MANUAL: update github recommendable with modified version inc new hooks
# MANUAL: switch recommendable to github.

# ensure we are using the most recent schema
RAILS_ENV=production bundle exec rake db:migrate
# the categories table was renamed when moving from retailer categories
# to global categories so will contain a large number of orphan entries
# delete these to avoid mismatches due to id collissions
RAILS_ENV=production bundle exec rake migrate_to_scraper:delete_all_categories
# bring in any new items which exist as the old Item model but not the new
# FullItem model, the blacklist ensures only new items are processed 
# so as long as it has been run recently this should be quite quick
RAILS_ENV=production bundle exec rake migrate_to_scraper:items
# queue up all items for scraping, now that the category structure has
# changed, all items need rescraping before they will show up. This is
# the main barrier to the site coming back up again so devote all available
# resources to starting workers on the scraper queue
RAILS_ENV=production bundle exec rake daily_scraper:queue_it_up
# mark all the current users as not having been migrated yet, this prevents
# their recommendations from being displayed and defaults then to random items
RAILS_ENV=production bundle exec rake migrate_to_scraper:mark_as_not_migrated
# migrate everyones item likes across to fullitem likes
RAILS_ENV=production bundle exec rake migrate_to_scraper:likes
# migrate everyones item dislikes across to fullitem dislikes
RAILS_ENV=production bundle exec rake migrate_to_scraper:dislikes
# queue up everyones recs to be regenerated. Once the scrape has completed,
# devote all resources to workers processing the recommendable queue
RAILS_ENV=production bundle exec rake migrate_to_scraper:regen_recs
