class AddFailCountToUploadLog < ActiveRecord::Migration
  def change
    add_column :upload_logs, :fail_count, :integer, default: 0
  end
end
