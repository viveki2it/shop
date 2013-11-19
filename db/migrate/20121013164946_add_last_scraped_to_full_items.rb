class AddLastScrapedToFullItems < ActiveRecord::Migration
  def change
    add_column :full_items, :last_scraped, :datetime

  end
end
