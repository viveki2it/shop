class AddMalenameToMasterCategories < ActiveRecord::Migration
  def change
    add_column :master_categories, :male_name, :string

  end
end
