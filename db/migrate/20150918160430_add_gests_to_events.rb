class AddGestsToEvents < ActiveRecord::Migration
  def up
    add_column :events, :guests, :integer, default: 0
  end

  def down
    add_column :events, :guests
  end
end
