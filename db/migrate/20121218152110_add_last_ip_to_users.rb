class AddLastIpToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_ip, :string

  end
end
