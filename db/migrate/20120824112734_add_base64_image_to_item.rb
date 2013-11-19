class AddBase64ImageToItem < ActiveRecord::Migration
  def change
    add_column :items, :base64_image, :text

  end
end
