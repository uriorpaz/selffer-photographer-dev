class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.references :share
      t.string :share_url
      t.integer :counter

      t.timestamps
    end
  end
end
