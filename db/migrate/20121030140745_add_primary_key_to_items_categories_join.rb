class AddPrimaryKeyToItemsCategoriesJoin < ActiveRecord::Migration
  def up
    add_column :categories_full_items, :id, :primary_key
  end

  def down
    remove_column :categories_full_items, :id
  end
end
