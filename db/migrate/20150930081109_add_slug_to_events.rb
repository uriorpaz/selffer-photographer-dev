class AddSlugToEvents < ActiveRecord::Migration
  def up
    add_column :events, :slug, :string
    add_index :events, :slug, unique: true
  end

  def down
    remove_column :events, :slug
  end
end
