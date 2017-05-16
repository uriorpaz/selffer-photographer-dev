class AddIndexUniqToPhotos < ActiveRecord::Migration
  def change
    add_index :photos, [:time_stamp, :event_id, :original_filename], unique: true
  end
end
