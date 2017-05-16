class AddOwnerToPhotographers < ActiveRecord::Migration
  def change
    add_column :photographers, :is_owner, :boolean, default: false
  end
end
