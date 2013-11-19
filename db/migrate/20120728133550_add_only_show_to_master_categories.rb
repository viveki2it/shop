class AddOnlyShowToMasterCategories < ActiveRecord::Migration
  def change
    add_column :master_categories, :only_show_to, :string

  end
end
