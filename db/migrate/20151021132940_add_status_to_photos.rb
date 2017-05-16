class AddStatusToPhotos < ActiveRecord::Migration
  def up
    add_column :photos, :status, :integer, default: 0
    remove_column :photos, :background
  end

  def down
    add_column :photos, :background, :bolean, defailt: false
    remove_column :photos, :status, :integer, default: 0
  end
end
