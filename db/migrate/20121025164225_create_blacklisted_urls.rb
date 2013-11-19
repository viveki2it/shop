class CreateBlacklistedUrls < ActiveRecord::Migration
  def change
    create_table :blacklisted_urls do |t|
      t.text :url

      t.timestamps
    end
  end
end
