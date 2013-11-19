class DropFullTextSaves < ActiveRecord::Migration
  def up
    remove_column :full_item_histories, :doc
  end

  def down
    add_column :full_item_histories, :doc, :text
  end
end

