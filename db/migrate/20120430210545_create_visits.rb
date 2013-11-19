class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.integer :user_id
      t.text :site

      t.timestamps
    end
  end
end
