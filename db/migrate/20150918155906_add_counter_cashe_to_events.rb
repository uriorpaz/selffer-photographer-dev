class AddCounterCasheToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :photos_count, :integer, :default => 0
  end

  def self.down
    remove_column :events, :photos_count
  end
end
