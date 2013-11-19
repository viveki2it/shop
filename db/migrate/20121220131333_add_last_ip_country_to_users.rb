class AddLastIpCountryToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_ip_country, :string

  end
end
