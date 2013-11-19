class AddSaleOriginalPriceRemoveToRetailers < ActiveRecord::Migration
  def change
    add_column :retailers, :sale_original_price_remove_from_price, :text

  end
end
