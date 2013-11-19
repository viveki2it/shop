class CreateLandingPageLayouts < ActiveRecord::Migration
  def change
    create_table :landing_page_layouts do |t|
      t.string :title
      t.string :partial

      t.timestamps
    end
  end
end
