class AddModerationToEvent < ActiveRecord::Migration
  def change
    add_column :events, :needs_moderation, :boolean, default: false
  end
end
