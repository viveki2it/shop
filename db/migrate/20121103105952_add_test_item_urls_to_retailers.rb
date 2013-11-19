class AddTestItemUrlsToRetailers < ActiveRecord::Migration
  def change
    add_column :retailers, :normal_item_url, :text
    add_column :retailers, :sale_item_url, :text
  end
end
