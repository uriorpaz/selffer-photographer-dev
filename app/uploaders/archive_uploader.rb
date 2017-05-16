class ArchiveUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :aws

  def filename
    if original_filename.include?('.zip')
      original_filename.split('.')[0]+'.zip'
    else
      original_filename
    end
  end

  def store_dir
    "selffer-photographer/#{ENV['CUSTOM_ENV'] || Rails.env}/#{model.class.to_s.underscore}/#{model.id}/#{mounted_as}"
    # "selffer/production/face_image/55/image/2015-04-27-14_26_09.jpg"
  end
end