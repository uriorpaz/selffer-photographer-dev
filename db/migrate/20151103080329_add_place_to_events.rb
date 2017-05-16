class AddPlaceToEvents < ActiveRecord::Migration
  def change
    add_column :event_translations, :place, :string
  end
end
