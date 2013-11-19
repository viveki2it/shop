class AddExtractToSupportedDomains < ActiveRecord::Migration
  def change
    add_column :supported_domains, :index_based, :boolean
    add_column :supported_domains, :index, :integer

    add_column :supported_domains, :param_based, :boolean 
    add_column :supported_domains, :param_key, :string
  end
end
