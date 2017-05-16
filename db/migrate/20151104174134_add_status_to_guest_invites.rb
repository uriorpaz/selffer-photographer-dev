class AddStatusToGuestInvites < ActiveRecord::Migration
  def change
    remove_column :guest_invites, :status
    add_column :guest_invites, :status, :integer, default: 0
  end
end
