class CreateScrapeRecords < ActiveRecord::Migration
  def change
    create_table :scrape_records do |t|
      t.integer :retailer_id
      t.integer :succesful_items
      t.integer :enabled_items
      t.integer :failed_items
      t.integer :error_items

      t.timestamps
    end
  end
end
