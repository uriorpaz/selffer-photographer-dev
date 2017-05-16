class AddEventIdToLinks < ActiveRecord::Migration
  def change
    add_column :links, :event_id, :integer
  end
end
