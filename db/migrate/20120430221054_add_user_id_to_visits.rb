class AddUserIdToVisits < ActiveRecord::Migration
  def change
    add_column :visits, :user_id, :integer
    remove_column :visits, :userhash
  end
end
