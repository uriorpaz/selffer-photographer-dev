class SendArchiveWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(photo_ids, event_id, photographer_id)
    @photographer = Photographer.find(photographer_id)
    @event = Event.find(event_id)
    @photos = @event.photos.find(photo_ids)
    files = @photos.map { |p| {url: p.img,
                               name: (p.original_filename || "#{p.id}.jpg")}}
    # logger.info files
    archives = []
    photos_batch = 500
    counter = 0
    while files.length>counter
      temp_file = Tempfile.new("#{@event.slug || @event.name || @event.id}.zip")
      ZipFile.temp_zip(temp_file, files[counter...(counter+photos_batch)])
      temp_file.close
      @archive = @event.archives.new(email: @photographer.email)
      @archive.file = temp_file
      @archive.save
      archives << @archive
      counter += photos_batch
      temp_file.unlink
      logger.info "counter: #{counter}"
    end
    Pusher["Photographer-#{photographer_id}"].trigger('zip_created', @archive.file.url)
    ArchiveMailer.send_file(archives).deliver
  end
end
