class AddChangeStatusesToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :background, :boolean, default: false
    add_column :photos, :priv, :boolean, default: false
  end
end
