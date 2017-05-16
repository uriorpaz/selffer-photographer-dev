class AddAlbumToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :album, :boolean, default: :false
  end
end
