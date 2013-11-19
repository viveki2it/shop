class CreateLandingPageVariants < ActiveRecord::Migration
  def change
    create_table :landing_page_variants do |t|
      t.string :internal_title
      t.text :internal_description
      t.integer :landing_page_layout_id
      t.text :heading1
      t.text :heading2
      t.text :description
      t.string :download_button_text
      t.string :hero_image
      t.text :box1
      t.text :box2
      t.text :box3
      t.boolean :show_trending
      t.boolean :show_supported_shops

      t.timestamps
    end
  end
end
