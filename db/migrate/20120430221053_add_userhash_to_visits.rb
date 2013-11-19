class AddUserhashToVisits < ActiveRecord::Migration
  def change
    add_column :visits, :userhash, :string
    remove_column :visits, :user_id
  end
end
