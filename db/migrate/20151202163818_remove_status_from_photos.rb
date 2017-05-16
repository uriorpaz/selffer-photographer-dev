class RemoveStatusFromPhotos < ActiveRecord::Migration
  def change
    remove_column :photos, :status
  end
end
