class CreateWatermarks < ActiveRecord::Migration
  def change
    create_table :watermarks do |t|
      t.references :photographer, index: true, foreign_key: true
      t.boolean :is_portrait
      t.boolean :is_default
      t.string :image_filename

      t.timestamps null: false
    end
  end
end
