class CreateRetailerCategories < ActiveRecord::Migration
  def change
    create_table :retailer_categories do |t|
      t.string :name
      t.integer :retailer_id
      t.integer :master_category_id

      t.timestamps
    end
  end
end
