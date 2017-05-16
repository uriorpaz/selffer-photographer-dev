class AddCommentToPhotos < ActiveRecord::Migration
  def up
    add_column :photos, :comment, :string
  end

  def down
    remove_column :photos, :comment
  end
end
