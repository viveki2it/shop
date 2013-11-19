class AddShowThreeBoxesToLandingPageVariants < ActiveRecord::Migration
  def change
    add_column :landing_page_variants, :show_three_boxes, :boolean
  end
end
