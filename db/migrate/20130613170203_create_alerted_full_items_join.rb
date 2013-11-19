class CreateAlertedFullItemsJoin < ActiveRecord::Migration
  def change
    create_table :alerted_full_items, :id => false do |t|
      t.integer :full_item_id
      t.integer :user_id
    end
  end
end
