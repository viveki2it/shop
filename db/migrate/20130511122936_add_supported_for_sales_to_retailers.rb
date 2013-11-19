class AddSupportedForSalesToRetailers < ActiveRecord::Migration
  def change
    add_column :retailers, :supported_for_sales, :boolean
  end
end
