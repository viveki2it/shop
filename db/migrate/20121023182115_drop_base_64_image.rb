class DropBase64Image < ActiveRecord::Migration
  def up
    #remove_column :items, :base_64_image
  end

  def down
    add_column :items, :base_64_image, :binary
  end
end
