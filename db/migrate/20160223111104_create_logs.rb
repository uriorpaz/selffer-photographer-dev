class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.references :event, index: true, foreign_key: true
      t.datetime :start_at
      t.datetime :end_at
      t.integer :photo_amount
      t.integer :status
      t.text :text

      t.timestamps null: false
    end
  end
end
