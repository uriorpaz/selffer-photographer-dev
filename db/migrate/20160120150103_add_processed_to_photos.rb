class AddProcessedToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :is_processed, :boolean, default: false
  end
end
