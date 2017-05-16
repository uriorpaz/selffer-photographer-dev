class ChangeTimeStampForPhotos < ActiveRecord::Migration
  def up
    change_column :photos, :time_stamp, 'bigint USING CAST(time_stamp AS bigint)'
  end

  def down
    change_column :photos, :time_stamp, :string
  end
end
