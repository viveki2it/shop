class AddCategorySelectorToSupportedDomain < ActiveRecord::Migration
  def change
    add_column :supported_domains, :category_selector, :string

  end
end
