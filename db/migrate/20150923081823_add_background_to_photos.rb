class AddBackgroundToPhotos < ActiveRecord::Migration
  def up
    add_column :photos, :background, :boolean, default: false
  end

  def down
    remove_column :photos, :background
  end
end
