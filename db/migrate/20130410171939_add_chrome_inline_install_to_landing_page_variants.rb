class AddChromeInlineInstallToLandingPageVariants < ActiveRecord::Migration
  def change
    add_column :landing_page_variants, :chrome_inline_install, :boolean
  end
end
