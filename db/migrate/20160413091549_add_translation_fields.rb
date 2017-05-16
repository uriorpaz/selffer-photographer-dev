class AddTranslationFields < ActiveRecord::Migration
  def change
    add_column :events, :type, :string
    add_column :events, :place, :string
    add_column :events, :pre_text, :text
    add_column :events, :description, :text
    add_column :events, :long_description, :text
  end
end
