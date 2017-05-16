class CreateErrorLogs < ActiveRecord::Migration
  def change
    create_table :error_logs do |t|
      t.references :upload_log
      t.text :message

      t.timestamps null: false
    end
  end
end
