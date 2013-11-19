class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :supported_site_id
      t.text :title
      t.text :image

      t.timestamps
    end
  end
end
