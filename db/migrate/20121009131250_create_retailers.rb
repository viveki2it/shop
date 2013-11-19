class CreateRetailers < ActiveRecord::Migration
  def change
    create_table :retailers do |t|
      t.string :name
      t.string :display_name
      t.string :domain
      t.boolean :enabled
      t.boolean :index_based
      t.integer :index
      t.boolean :param_based
      t.string :param_name
      t.boolean :url_based
      t.string :image_selector
      t.boolean :colour_dropdown
      t.string :colour_dropdown_selector
      t.boolean :colour_link
      t.string :colour_link_selector
      t.boolean :normal_simple_price
      t.string :normal_simple_price_selector
      t.boolean :normal_composite_price
      t.string :normal_composite_price_selectors
      t.string :normal_composite_price_indexes
      t.string :normal_remove_from_price
      t.boolean :sale_simple_price
      t.string :sale_simple_price_selector
      t.boolean :sale_composite_price
      t.string :sale_composite_price_selectors
      t.string :sale_composite_price_indexes
      t.string :sale_remove_from_price
      t.string :category_selector
      t.boolean :always_male
      t.boolean :always_female

      t.timestamps
    end
  end
end
