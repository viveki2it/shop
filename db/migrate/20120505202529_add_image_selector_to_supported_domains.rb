class AddImageSelectorToSupportedDomains < ActiveRecord::Migration
  def change
    add_column :supported_domains, :selector, :string

  end
end
