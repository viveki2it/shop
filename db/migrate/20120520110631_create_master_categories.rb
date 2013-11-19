class CreateMasterCategories < ActiveRecord::Migration
  def change
    create_table :master_categories do |t|
      t.string :name

      t.timestamps
    end
  end
end
