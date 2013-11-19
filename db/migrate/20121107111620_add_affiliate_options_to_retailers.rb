class AddAffiliateOptionsToRetailers < ActiveRecord::Migration
  def change
    add_column :retailers, :use_affiliate_window, :boolean
    add_column :retailers, :affiliate_window_awinmid, :string
    add_column :retailers, :use_linkshare, :boolean
    add_column :retailers, :linkshare_offerid, :string
    add_column :retailers, :linkshare_tmpid, :string
  end
end
