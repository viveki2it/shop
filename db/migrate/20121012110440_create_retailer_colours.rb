class CreateRetailerColours < ActiveRecord::Migration
  def change
    create_table :retailer_colours do |t|
      t.string :name
      t.integer :retailer_id
      t.integer :master_colour_id

      t.timestamps
    end
  end
end
