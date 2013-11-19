class AddOnSaleToFullItem < ActiveRecord::Migration
  def change
    add_column :full_items, :on_sale, :boolean

  end
end
