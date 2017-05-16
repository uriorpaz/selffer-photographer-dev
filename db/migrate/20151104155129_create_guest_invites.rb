class CreateGuestInvites < ActiveRecord::Migration
  def change
    create_table :guest_invites do |t|
      t.references :photographer, index: true, foreign_key: true
      t.references :event, index: true, foreign_key: true
      t.string :email
      t.string :phone
      t.string :code
      t.string :status

      t.timestamps null: false
    end
  end
end
