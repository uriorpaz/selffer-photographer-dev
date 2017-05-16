class EventSyncWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 3, queue: "default"

  sidekiq_retry_in do |count|
    (count)*10
  end

  def perform(event_id)
    event = Event.find(event_id)
    translations = event.event_translations.map &:to_sync
    query = { event:
              { slug: event.slug,
                date: event.decorate_date,
                name: event.name,
                translations: translations,
                id: event.id
              },
              photographer:
              {id: event.photographer_id}
            }
    SyncData.send_request('/events/receive', query )
  end
end