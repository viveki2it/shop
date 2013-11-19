class AddLastVisitedToFullItems < ActiveRecord::Migration
  def change
    add_column :full_items, :last_visited, :datetime

  end
end
