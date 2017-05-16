class ChangeDefaultToWatermarks < ActiveRecord::Migration
  def change
    change_column :watermarks, :is_portrait, :boolean, default: true
  end
end
