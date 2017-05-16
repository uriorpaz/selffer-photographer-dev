class AddLongToEventTranslations < ActiveRecord::Migration
  def change
    add_column :event_translations, :long_description, :text
  end
end
