class CreateSupportedDomains < ActiveRecord::Migration
  def change
    create_table :supported_domains do |t|
      t.string :domain

      t.timestamps
    end
  end
end
