class PhotographerSyncWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 3, queue: "default"

  sidekiq_retry_in do |count|
    (count)*10
  end

  def perform(photographer_id)
    photographer = Photographer.find(photographer_id)
    query = {photographer: {email: photographer.email,
                            full_name: photographer.name,
                            logo_url: photographer.logo.url,
                            brand_name: photographer.studio_name,
                            website: photographer.website,
                            phone: photographer.mobile_number,
                            fb_link: photographer.facebook,
                            twitter_link: photographer.twitter}
                          }
    SyncData.send_request('/photographers/receive', query )
  end
end