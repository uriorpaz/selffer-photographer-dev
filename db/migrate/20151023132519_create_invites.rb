class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.references :photographer, index: true, foreign_key: true
      t.references :event, index: true, foreign_key: true
      t.string :invited_email
      t.integer :invited_id, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
