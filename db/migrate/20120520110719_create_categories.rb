class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.integer :master_category_id
      t.string :name

      t.timestamps
    end
  end
end
