class AddIndexToItemHistoriesForeignKeys < ActiveRecord::Migration
  def self.up
    add_index :full_item_histories, :full_item_id
  end

  def self.down
    remove_index :full_item_histories, :full_item_id
  end
end
