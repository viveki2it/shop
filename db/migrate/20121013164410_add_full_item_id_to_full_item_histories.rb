class AddFullItemIdToFullItemHistories < ActiveRecord::Migration
  def change
    add_column :full_item_histories, :full_item_id, :integer

  end
end
