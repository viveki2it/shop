class AddInviteCodeToSignups < ActiveRecord::Migration
  def change
    add_column :signups, :invite_id, :integer
  end
end
