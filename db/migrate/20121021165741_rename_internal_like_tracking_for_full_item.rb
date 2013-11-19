class RenameInternalLikeTrackingForFullItem < ActiveRecord::Migration
  def up
    rename_column :recorded_likes, :item_id, :full_item_id
  end

  def down
    rename_column :recorded_likes, :full_item_id, :item_id
  end
end
