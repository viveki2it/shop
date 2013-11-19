class AddImageLinkToItem < ActiveRecord::Migration
  def change
    add_column :items, :image_link, :text

  end
end
