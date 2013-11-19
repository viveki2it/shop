class CreateRecordedLikes < ActiveRecord::Migration
  def change
    create_table :recorded_likes do |t|
      t.integer :item_id
      t.integer :user_id
      t.string :source
      t.date :recorded_date

      t.timestamps
    end
  end
end
