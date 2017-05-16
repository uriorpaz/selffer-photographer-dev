class AddSomeWatermarkToEvents < ActiveRecord::Migration
  def change
    add_column :events, :watermark_portrait_id, :integer
    add_column :events, :watermark_landscape_id, :integer
  end
end
