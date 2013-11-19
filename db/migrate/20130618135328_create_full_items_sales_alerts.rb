class CreateFullItemsSalesAlerts < ActiveRecord::Migration
  def change
    create_table :full_items_sales_alerts, :id => false do |t|
      t.integer :full_item_id
      t.integer :sales_alert_id
    end
  end
end
