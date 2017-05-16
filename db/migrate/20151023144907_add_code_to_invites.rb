class AddCodeToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :code, :string
  end
end
