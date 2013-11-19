class AddMigratedToNewScraperToUsers < ActiveRecord::Migration
  def change
    add_column :users, :migrated_to_new_scraper, :boolean, :default => true

  end
end
