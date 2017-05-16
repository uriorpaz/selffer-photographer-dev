# encoding: utf-8

class PhotoUploader < CarrierWave::Uploader::Base
  # include ::CarrierWave::Backgrounder::Delay

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  # storage :file
  include CarrierWaveDirect::Uploader
  # storage :aws

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    #"selffer/#{ENV['CUSTOM_ENV'] || Rails.env}/#{model.class.to_s.underscore}/#{model.id}/#{mounted_as}"
    # "selffer/#{ENV['CUSTOM_ENV'] || Rails.env}/#{model.class.to_s.underscore}/#{model.id}/#{mounted_as}"
    "selffer/#{ENV['CUSTOM_ENV'] || Rails.env}/#{model.class.to_s.underscore}/#{model.id}/#{mounted_as}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :resize_to_fit => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   if original_filename && original_filename == @filename
  #     random_name = SecureRandom.uuid
  #     while Photo.find_by_img("#{random_name}.#{file.extension}") do
  #       random_name = SecureRandom.uuid
  #     end
  #     @filename = "#{random_name}.#{file.extension}".downcase
  #   else
  #     @filename.to_s.downcase
  #   end
  # end

  # def download_url(filename)
  #   url(response_content_disposition: %Q{attachment; filename="#{filename}"})
  # end

end
