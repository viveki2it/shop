class CreateOnSaleItems < ActiveRecord::Migration
  def change
    create_table :on_sale_items do |t|
      t.integer :full_item_id

      t.timestamps
    end
  end
end
