class CreateEventTranslations < ActiveRecord::Migration
  def change
    create_table :event_translations do |t|
      t.string :name
      t.text :description
      t.string :event_type
      t.string :lang
      t.references :event, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
