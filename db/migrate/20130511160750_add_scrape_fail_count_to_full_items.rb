class AddScrapeFailCountToFullItems < ActiveRecord::Migration
  def change
    add_column :full_items, :scrape_fail_count, :integer, default: 0
    add_column :full_items, :scrape_success_count, :integer, default: 0
  end
end
