class AddCountToUploadLogs < ActiveRecord::Migration
  def change
    add_column :upload_logs, :not_photo_count, :integer
  end
end
