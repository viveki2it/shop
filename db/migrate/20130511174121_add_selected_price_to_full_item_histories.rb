class AddSelectedPriceToFullItemHistories < ActiveRecord::Migration
  def change
    add_column :full_item_histories, :selected_price, :float
  end
end
