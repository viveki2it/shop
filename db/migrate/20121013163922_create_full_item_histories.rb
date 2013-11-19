class CreateFullItemHistories < ActiveRecord::Migration
  def change
    create_table :full_item_histories do |t|
      t.text :doc
      t.float :normal_price
      t.float :sale_price
      t.float :original_price
      t.boolean :enabled
      t.boolean :valid_item

      t.timestamps
    end
  end
end
