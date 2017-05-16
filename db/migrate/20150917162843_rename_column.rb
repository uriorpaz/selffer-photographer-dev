class RenameColumn < ActiveRecord::Migration
  def change
    rename_column :photographers, :nams, :name
  end
end
