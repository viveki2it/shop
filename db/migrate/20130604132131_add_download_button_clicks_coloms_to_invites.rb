class AddDownloadButtonClicksColomsToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :download_button_clicks, :integer, :default => 0
  end
end
