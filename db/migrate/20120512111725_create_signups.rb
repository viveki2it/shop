class CreateSignups < ActiveRecord::Migration
  def change
    create_table :signups do |t|
      t.text :email

      t.timestamps
    end
  end
end
