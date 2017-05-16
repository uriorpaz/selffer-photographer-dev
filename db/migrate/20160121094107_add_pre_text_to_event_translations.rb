class AddPreTextToEventTranslations < ActiveRecord::Migration
  def change
    add_column :event_translations, :pre_text, :text
  end
end
