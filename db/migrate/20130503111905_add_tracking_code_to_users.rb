class AddTrackingCodeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tracking_code, :string
  end
end
