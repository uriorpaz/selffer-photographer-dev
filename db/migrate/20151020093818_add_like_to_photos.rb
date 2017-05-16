class AddLikeToPhotos < ActiveRecord::Migration
  def up
    add_column :photos, :like, :boolean, default: false
  end

  def down
    remove_column :photos, :like
  end
end
