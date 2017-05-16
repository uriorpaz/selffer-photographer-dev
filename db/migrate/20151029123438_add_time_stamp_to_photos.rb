class AddTimeStampToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :time_stamp, :string
  end
end
