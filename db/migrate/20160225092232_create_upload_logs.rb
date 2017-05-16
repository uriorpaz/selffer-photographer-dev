class CreateUploadLogs < ActiveRecord::Migration
  def change
    create_table :upload_logs do |t|
      t.references :event, index: true, foreign_key: true
      t.datetime :start_at
      t.datetime :end_at
      t.integer :photos_start_count
      t.integer :error_logs_count
      t.integer :duplicates_count
      t.integer :photos_end_count

      t.timestamps null: false
    end
  end
end
