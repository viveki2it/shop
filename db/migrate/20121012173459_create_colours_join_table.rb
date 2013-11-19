class CreateColoursJoinTable < ActiveRecord::Migration
  def change
    create_table :full_items_retailer_colours, :id => false do |t|
      t.references :full_item, :null => false
      t.references :retailer_colour, :null => false
    end
  end
end
