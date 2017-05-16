class ChangeDefaultSendNotificationForEvents < ActiveRecord::Migration
  def change
    change_column :events, :send_notification, :boolean, :default => false
  end
end
