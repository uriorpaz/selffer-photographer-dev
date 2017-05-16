class AddEventToArchives < ActiveRecord::Migration
  def change
    add_reference :archives, :event, index: true, foreign_key: true
  end
end
