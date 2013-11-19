class AddFullItemIdToFullItem < ActiveRecord::Migration
  def change
    add_column :full_items, :full_item_id, :integer

  end
end
