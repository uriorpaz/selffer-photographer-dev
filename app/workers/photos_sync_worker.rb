class PhotosSyncWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 3, queue: "default"

  sidekiq_retry_in do |count|
    (count)*10
  end

  def perform(photo_ids)
    photos = Photo.find(photo_ids)
    event = photos.first.event
    photos = photos.map{|photo| {url: photo.img_url_low,
                                 background: photo.background,
                                 privat: photo.priv,
                                 album: photo.album,
                                 time_stamp: photo.time_stamp}
                        }
    query = { photos: photos,
              event: {id: event.id}
            }
    SyncData.send_request('/photos/receive', query )
  end
end
