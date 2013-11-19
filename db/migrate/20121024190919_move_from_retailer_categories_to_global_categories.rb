class MoveFromRetailerCategoriesToGlobalCategories < ActiveRecord::Migration
  def up
    rename_column :full_items_retailer_categories, :retailer_category_id, :category_id
  end

  def down
    rename_column :full_items_retailer_categories, :category_id, :retailer_category_id
  end
end
