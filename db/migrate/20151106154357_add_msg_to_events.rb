class AddMsgToEvents < ActiveRecord::Migration
  def change
    add_column :events, :share_message, :text
  end
end
