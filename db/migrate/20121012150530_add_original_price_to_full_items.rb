class AddOriginalPriceToFullItems < ActiveRecord::Migration
  def change
    add_column :full_items, :sale_original_price, :float

  end
end
