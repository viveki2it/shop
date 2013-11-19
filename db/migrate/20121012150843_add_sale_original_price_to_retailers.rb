class AddSaleOriginalPriceToRetailers < ActiveRecord::Migration
  def change
    add_column :retailers, :sale_original_price, :boolean
    add_column :retailers, :sale_original_price_simple_price, :boolean
    add_column :retailers, :sale_original_price_simple_price_selector, :string
    add_column :retailers, :sale_original_price_composite_price, :boolean
    add_column :retailers, :sale_original_price_composite_price_selectors, :string
    add_column :retailers, :sale_original_price_composite_price_indexes, :string

  end
end
