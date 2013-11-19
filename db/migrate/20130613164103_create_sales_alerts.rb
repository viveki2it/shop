class CreateSalesAlerts < ActiveRecord::Migration
  def change
    create_table :sales_alerts do |t|
      t.integer :user_id
      t.boolean :email_sent, :default => false
      t.timestamps
    end
  end
end
