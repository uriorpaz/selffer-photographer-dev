class PhotosController < ApplicationController
  # require 'opencv'
  # include OpenCV
  skip_before_filter  :verify_authenticity_token, only: :destroy
  skip_before_action :authenticate_any!, only: :processed
  before_action :find_event, except: :processed
  before_action :find_photographer, except: :processed
  before_action :sync_event, only: :create
  # after_action :send_photo_to_main_server, only: :create
  HEADER = { 'Content-Type' => 'application/json; charset=UTF-8', 'Accept' => 'application/json' }

  def index
    @sort = params[:sort] || 'asc'
    @tags = @event.tag_list
    @tag = params[:tag]
    @photos = get_photos(params[:type]).processed.is_show.order(time_stamp: @sort)
    if params[:photos_hidden]
      params[:photos_hidden] = params[:photos_hidden].split(',').map(&:to_i)
      if params[:exclude]=='true'
        params[:photos_hidden] = @photos.pluck(:id)-params[:photos_hidden]
      end
      @photos = @event.photos.processed.is_show.find(params[:photos_hidden])
    else
      @photos = @photos.order(created_at: params[:sort] || 'asc')
      @photos = @photos.tagged_with(@tag) if @tag
      @photos = @photos.page(params[:page]) if params[:page]
    end
    respond_to do |format|
      format.json do
        files = @photos.map { |p| {url: p.img_url_high, name: p.original_filename}}
        render json: { files: files }
      end
      format.zip do
        ArchiveMailer.generate_file_started(current_photographer.email, @event).deliver
        flash[:notice] = t("photographer_client.notification.photos_generating")
        SendArchiveWorker.perform_async(@photos.map(&:id), @event.id, current_photographer.id)
        redirect_to event_path(@event)
        # ahoy.track 'download_all_photos', event_id: @event.id
      end
      format.html {render @photos}
    end
  end

  def create
    @photo = @event.photos.create(photo_params)
    @event.tag_list.add(params[:photo][:tag_list])
    @event.save
    @tags = @event.tag_list
    # @event.invites.where(code: nil).each(&:send_code) if params[:photo][:is_last] == "true"
    # url = "http://ec2-52-30-40-109.eu-west-1.compute.amazonaws.com/faceush/api/Process.svc/help/operations/UploadLowResImage"
    # image = "https://selffer.s3.amazonaws.com/selffer/development/events/00006502-cbb4-4873-975e-68bbfefd5c67/pictures/high/f396fe93a06323837029bd605ecf8128.jpg"
    # body = {"ImageUrl" => image}
    # # HTTParty.post url, body
    # UploadPhotosWorker.perform_async
    @photo_count = @event.photos.count
    @process_count = @event.photos.not_processed.count
    @upload_log = UploadLog.find(params[:photo][:upload_log_id])
    @upload_log.update_attribute(:photos_end_count, @upload_log.photos_end_count += 1) if @upload_log
    respond_to do |format|
      format.html do
        unless @photos.any?{|p| p.error}
          flash[:notice] = "Photos loaded" if @photos.present?
        else
          flash[:alert] = @photos.find{|p| p.error}.error
        end
        redirect_to event_path(@event)
      end
      format.js {}
    end
  end

  def update
    @photos = @event.photos.processed
    @photo = @photos.find params[:id]
    @photo.assign_attributes photo_params
    url = ApiUrlHelper.api_url_eb + "/event/#{@event.id}/photo/#{params[:id]}?isThirdPartyPhotoId=1"
    body = {IsPrivate: "#{@photo.priv}",
            IsAlbum: "#{@photo.album}",
            IsPinned: "#{@photo.always_show}"}.to_json
    response = HTTParty.put( url, body: body, headers: HEADER )
    need_sync = @photo.album_changed? || @photo.priv_changed?
    status = @photo.save ? 202 : 422
    if need_sync && status==202
      # PhotosSyncWorker.perform_async([@photo.id]) unless Rails.env=="development"
    end
    @like_count = @photos.likes.count if photo_params[:like]
    if photo_params[:priv]
      @priv_count = @photos.privs.count
      @not_priv_count = @photos.count - @priv_count
      @bg_count = @photos.backgrounds.count
    end
    @album_count = @photos.albums.count if photo_params[:album]
    respond_to do |f|
      f.js{}
      f.json {
        render nothing: true, status: status
      }
    end
  end

  def processed
    @event = Event.find(params[:event_id])
    @tags = @event.tag_list
    @photo = @event.photos.find(params[:photo_id])
    @photo.update(is_processed: true)
    @photo.set_size
    chanel = Pusher["Event-#{@event.id}"]
    if chanel.info[:occupied]
      photo_data = render_to_string @photo
      process_count = @event.photos.processed.count
      all_count = @event.photos.count
      public_count = process_count-@event.photos.privs.count
      chanel.trigger('add_image', {photo_data: photo_data,
                                   process_count: process_count,
                                   all_count: all_count,
                                   public_count: public_count})
    end
    respond_to do |f|
      f.json {
        render nothing: true, status: status
      }
      f.html{render nothing: true}
    end
  end

  def toggle_tag
    @photo = @event.photos.find(params[:photo_id])
    @tag = URI.decode params[:tag]
    if @photo.tag_list.include?(@tag)
      @photo.tag_list.remove(@tag)
    else
      @photo.tag_list.add(@tag)
    end
    @photo.save
    @count = @event.photos.tagged_with(@tag).count
  end

  private
  def photo_params
    params.require(:photo).permit(:comment, :like, :priv, :background, :album,
                                  :original_filename, :img, :time_stamp, :tag_list)
  end

  def send_photo_to_main_server
    PhotosSyncWorker.perform_async([@photo.id]) unless Rails.env=="development"
  end

  def sync_event
    unless @event.name || @event.date
      @event.update(updated_at: Time.zone.now)
      # EventSyncWorker.perform_async(@event.id) unless Rails.env=="development"
    end
  end

  def set_file_name
    @original_filenames = []
    params[:files].each do |file|
      file_name = file.original_filename
      @original_filenames << file_name
      extension = file_name.split('.').last
      random_name = SecureRandom.uuid
      while Photo.find_by_img("#{random_name}.#{extension}") do
        random_name = SecureRandom.uuid
      end
      file.original_filename = "#{random_name}.#{extension}".downcase
    end
  end
end
