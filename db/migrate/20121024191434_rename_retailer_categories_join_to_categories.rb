class RenameRetailerCategoriesJoinToCategories < ActiveRecord::Migration
  def up
    rename_table :full_items_retailer_categories, :categories_full_items
  end

  def down
    rename_table :categories_full_items, :full_items_retailer_categories
  end
end
