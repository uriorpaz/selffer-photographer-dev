class UploadPhotosWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 10, queue: "critical"

  sidekiq_retry_in do |count|
    (count)*5
  end

  URL = ApiUrlHelper.api_url "/faceush/api/process.svc/uploadimage"
  HEADERS = { 'Content-Type' => 'application/json; charset=UTF-8', 'Accept' => 'application/json' }
  BUCKET = Rails.application.secrets[:env]['S3_BUCKET_NAME']

  def perform
    photos = Photo.where(is_processed: false)
    if (photos.any?)
      event = photos.first.event
      photos.each do |photo|
        body = {
                  "EventId"=>event.id,
                  "ImageIdentifier"=> {
                    "CameraId"=>"",
                    "FileName"=>photo.original_filename,
                    "Timestamp"=>photo.time_stamp
                  },
                  "ImageUrl"=>photo.img.gsub('https://selffer.s3.amazonaws.com',"#{BUCKET}"),
                  "UserId"=>event.photographer_id
                }.to_json
        puts body
        request = HTTParty.post(URL, body: body, headers: HEADERS)
        puts request
        if request["IsError"]
          photo.destroy
        else
          photo.update(is_processed: true)
        end
      end
    end
  end
end
