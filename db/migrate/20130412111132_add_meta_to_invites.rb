class AddMetaToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :owner, :string
    add_column :invites, :proposition_code, :string
    add_column :invites, :proposition_details, :text
    add_column :invites, :image_code, :string
    add_column :invites, :advert_heading, :string
    add_column :invites, :advert_body, :text
  end
end