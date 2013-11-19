class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.string :code
      t.integer :ambassador_id
      t.boolean :include_in_leaderboard

      t.timestamps
    end
  end
end
