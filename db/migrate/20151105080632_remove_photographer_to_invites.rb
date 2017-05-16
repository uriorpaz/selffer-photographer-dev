class RemovePhotographerToInvites < ActiveRecord::Migration
  def change
    remove_column :invites, :photographer_id
    remove_column :guest_invites, :photographer_id
  end
end
