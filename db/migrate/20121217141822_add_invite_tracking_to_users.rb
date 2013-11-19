class AddInviteTrackingToUsers < ActiveRecord::Migration
  def change
    add_column :users, :invite_code, :string
    add_column :users, :last_started_extension, :datetime

  end
end
