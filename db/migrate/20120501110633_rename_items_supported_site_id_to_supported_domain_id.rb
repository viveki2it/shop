class RenameItemsSupportedSiteIdToSupportedDomainId < ActiveRecord::Migration
  def up
  	rename_column :items, :supported_site_id, :supported_domain_id
  end

  def down
  	rename_column :items, :supported_domain_id, :supported_site_id
  end
end
