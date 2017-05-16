class AddColumnsForOneDbToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :image_size, :string
    add_column :photos, :from_api, :boolean, default: false
    add_column :photos, :is_show, :boolean, default: true
    remove_column :photos, :img_tmp
  end
end
