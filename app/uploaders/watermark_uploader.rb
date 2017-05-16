class WatermarkUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :aws

  def store_dir
    "selffer/#{ENV['CUSTOM_ENV'] || Rails.env}/#{model.class.to_s.underscore}/#{model.id}/#{mounted_as}"
    # "selffer/production/face_image/55/image/2015-04-27-14_26_09.jpg"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  #http://fabianosoriani.wordpress.com/2012/11/10/carrierwave-limit-file-size-plus-gif-fix/
  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end 
end