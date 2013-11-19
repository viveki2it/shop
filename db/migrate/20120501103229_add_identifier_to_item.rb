class AddIdentifierToItem < ActiveRecord::Migration
  def change
    add_column :items, :identifier, :string

  end
end
