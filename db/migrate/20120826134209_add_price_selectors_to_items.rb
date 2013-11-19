class AddPriceSelectorsToItems < ActiveRecord::Migration
  def change
    add_column :supported_domains, :no_price, :boolean
    add_column :supported_domains, :use_simple_price_selector, :boolean
    add_column :supported_domains, :simple_price_selector, :string
    add_column :supported_domains, :use_composite_price_selector, :boolean
    add_column :supported_domains, :composite_price_selector, :string
    add_column :supported_domains, :composite_price_selector_index, :string
  end
end
