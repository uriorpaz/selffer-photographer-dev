class AddSlugToPhotographers < ActiveRecord::Migration
  def up
    add_column :photographers, :slug, :string
    add_index :photographers, :slug, unique: true
  end

  def down
    remove_column :photographers, :slug
  end
end
