class CreateFullItemsRetailerCategories < ActiveRecord::Migration
  def change
    create_table :full_items_retailer_categories, :id => false do |t|
      t.references :full_item, :null => false
      t.references :retailer_category, :null => false
    end
  end
end

