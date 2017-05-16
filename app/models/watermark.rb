class Watermark < ActiveRecord::Base
  belongs_to :photographer
  mount_uploader :image_filename, WatermarkUploader
end
