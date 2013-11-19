class AddDontDisplayToSupportedDomains < ActiveRecord::Migration
  def change
    add_column :supported_domains, :dont_display, :boolean

  end
end
