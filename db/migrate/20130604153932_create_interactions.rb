class CreateInteractions < ActiveRecord::Migration
  def change
    create_table :interactions do |t|
      t.string :user_identifier
      t.string :event_type
      t.integer :count
      t.references :target, :polymorphic => true
      t.timestamps
    end
  end
end
