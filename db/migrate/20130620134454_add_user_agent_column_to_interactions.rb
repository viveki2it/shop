class AddUserAgentColumnToInteractions < ActiveRecord::Migration
  def change
    add_column :interactions, :user_agent, :string
  end
end
