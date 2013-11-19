class CreateRetailerReports < ActiveRecord::Migration
  def change
    create_table :retailer_reports do |t|
      t.string :slug
      t.text :data

      t.timestamps
    end
  end
end
