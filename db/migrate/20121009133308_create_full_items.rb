class CreateFullItems < ActiveRecord::Migration
  def change
    create_table :full_items do |t|
      t.integer :retailer_id
      t.float :normal_price
      t.float :sale_price
      t.float :selected_price
      t.text :image_path
      t.string :gender
      t.text :identifier
      t.text :link
      t.boolean :enabled

      t.timestamps
    end
  end
end
