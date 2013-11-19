class CreateMasterColours < ActiveRecord::Migration
  def change
    create_table :master_colours do |t|
      t.string :name
      t.string :swatch

      t.timestamps
    end
  end
end
