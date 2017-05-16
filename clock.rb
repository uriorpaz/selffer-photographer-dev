require 'rubygems'
require './config/boot'
require './config/environment'
require 'clockwork'
include Clockwork

handler do |job|
  Photo.connection.reconnect!
  url = ApiUrlHelper.api_url "/faceush/api/process.svc/uploadimage"
  headers = { 'Content-Type' => 'application/json; charset=UTF-8', 'Accept' => 'application/json' }
  bucket = Rails.application.secrets[:env]['S3_BUCKET_NAME']
  batch = (ENV['PHOTO_PROCESS_BATCH'] || 6).to_i
  photos = Photo.where(is_processed: false).where(
    'processed_at <= :request_delay OR processed_at is NULL',
    request_delay: Time.now - (ENV['PHOTO_PROCESS_REPEAT'] || 30.minutes).to_i
  ).order('processed_at ASC NULLS FIRST').order(:created_at).first(batch)
  if (photos.any?)
    # photographer_id = photo.photographer.id
    body = photos.map do |photo|
       {
          "PhotoId"=>photo.id,
          "EventId"=>photo.event_id,
          "ImageIdentifier"=> {
            "CameraId"=>"",
            "FileName"=>photo.original_filename,
            "Timestamp"=>photo.time_stamp
          },
          "ImageUrl"=>photo.img.gsub('https://selffer.s3.amazonaws.com',"#{bucket}"),
          "UserId"=>'test'#becouse of event Error
        }
    end
    photos.each{|p| p.update(processed_at: Time.now)}
    body = body.to_json
    puts body
    request = HTTParty.post(url, body: body, headers: headers)
    puts request
    # if request["IsError"]
    #   photo.destroy
    # else
    #   photo.update(is_processed: true)
    # end
  end
end
every((ENV['PHOTO_PROCESS_DELAY'] || 60).to_i, 'upload_photos')
