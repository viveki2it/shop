class AddLandingPageLayoutIdToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :landing_page_variant_id, :integer
  end
end
