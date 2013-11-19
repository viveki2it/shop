class AddExtensionVersionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :extension_version, :string

  end
end
