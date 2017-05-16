class AddImgTmpToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :img_tmp, :string
  end
end
