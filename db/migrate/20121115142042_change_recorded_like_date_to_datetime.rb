class ChangeRecordedLikeDateToDatetime < ActiveRecord::Migration
  def up
    change_column :recorded_likes, :recorded_date, :datetime
  end

  def down
    change_column :recorded_likes, :recorded_date, :date
  end
end
