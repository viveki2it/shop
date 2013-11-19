class CreateUserRecsJoinTable < ActiveRecord::Migration
  def change
    create_table :user_recs, :id => false do |t|
      t.integer :full_item_id
      t.integer :user_id
    end
  end
end
