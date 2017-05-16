class AddInviteParamsToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :invite_subject, :string
    add_column :invites, :invite_message, :text
  end
end
