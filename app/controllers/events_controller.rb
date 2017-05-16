class EventsController < ApplicationController
  before_action :find_event, except: [:index, :create]
  before_action :find_photographer, except: :photo_dup
  before_action :normal_url, except: [:update, :destroy]
  before_action :photo_ids, only: [:delete_photos, :add_backgrounds]

  HEADERS = { 'Content-Type' => 'application/json; charset=UTF-8', 'Accept' => 'application/json' }

  def index
    @event = Event.new
    @events = @photographer.events.where.not(status: 1).not_empty.order(created_at: :desc)
    @events_shared = @photographer.shared_events.not_deleted.order(created_at: :desc)
    # @new_event = @photographer.events.empty.first_or_create
  end

  def edit
  end

  def create
    @event = @photographer.events.create
    @event.assign_attributes(event_params)
    respond_to do |f|
      if @event.save!
        status = 202
        f.html{redirect_to event_path(@event)}
      else
        status ||= 422
      end
    end
    translations = params[:event].delete(:lang)
    if translations
      translations.each do |k,v|
        @et = @event.event_translations.find_or_create_by(lang: k)
        @et.update event_translation_params(v)
      end
    end
  end

  def update
    translations = params[:event].delete(:lang)
    if translations
      translations.each do |k,v|
        @et = @event.event_translations.find_or_create_by(lang: k)
        @et.update event_translation_params(v)
      end
    end
    @event.restore_attributes
    @event.assign_attributes(event_params)
    respond_to do |f|
    if @event.save!
      # flash[:notice] = "Event successfully updated"
      status = 202
      f.html { redirect_to event_path(@event) }
      f.json { respond_with_bip(@event) }
      f.js {}
    else
      # flash[:alert] = "Service not available. try again later"
      status ||= 422
    end
   end
    @event.save unless @event.slug
    # respond_to do |f|
    #   f.html { redirect_to event_path(@event) }
    #   f.json { render nothing: true, status: status }
    #   f.json { respond_with_bip(@event) }
    #   f.js {}

  end

  def show
    gon.restrictFolderDrag =  t "photographer_client.drag_folder_restrict"
    @base_uri = ENV['STAGING_MAIN_SERVER_URL'] || Rails.application.secrets[:env]['MAIN_SERVER_URL']
    gon.event_id = @event.id.to_s
    gon.is_photographer = photographer_signed_in? && !admin_signed_in?
    # Rails.logger.warn("Look at me, I'm a warning")
    @sort = params[:sort] || 'asc'
    @type = params[:type]
    @types = ['backgrounds', 'album', 'like', 'priv', 'not_priv']
    @photos = @event.photos.processed.is_show.includes(:tags)
    # @photos.each do |photo|
    #   link = photo.img
    #   name = link.split('/').last
    #   encoded_name =  ERB::Util.url_encode(URI.decode(name))
    #   url = link.gsub(name, encoded_name)
    #   photo.update_attribute(:img, url)
    # end
    @tag = params[:tag].presence
    @tags = @event.tag_list
    @tags_count = @tags.flat_map{|t| [t, @photos.tagged_with(t).count]}
    @tags_count = Hash[*@tags_count]
    @process_count = @event.photos.not_processed.count
    @photos = @photos.order(time_stamp: @sort)
    gon.backgrounds = @photos.backgrounds.pluck(:id)
    @all_count = @photos.count
    @bg_count = @photos.backgrounds.count
    @album_count = @photos.albums.count
    @like_count = @photos.likes.count
    @priv_count = @photos.privs.count
    # @photo_ids = @photos.page(1).pluck(:id)
    # @photo_ids += @photos.backgrounds.page(1).pluck(:id)
    # @photo_ids += @photos.albums.page(1).pluck(:id)
    # @photo_ids += @photos.likes.page(1).pluck(:id)
    # @photo_ids += @photos.privs.page(1).pluck(:id)
    # @photos = @photos.find(@photo_ids.uniq)
    @photos = get_photos(params[:type]).processed.is_show.includes(:tags)
    @photos = @photos.tagged_with(URI.decode(@tag)) if @tag
    @photos = @photos.order(time_stamp: @sort).page(1)
    @invites = @event.invites
  end

  def destroy
    @event.deleted!
    flash[:alert] = "Event deleted"
    redirect_to photographer_events_path(@photographer)
  end

  def delete_photos
    @all_photos = @event.photos.processed
    @all_count = @all_photos.count
    @bg_count = @all_photos.backgrounds.count
    @priv_count = @all_photos.privs.count
    @not_priv_count = @all_count - @priv_count
    @like_count = @all_photos.likes.count
    @album_count = @all_photos.albums.count
    @photos = get_photos(params[:type]).where(id: @photo_ids).destroy_all
    @photo_ids.each do |photo_id|
      url = ApiUrlHelper.api_url_eb "/event/#{@event.id}/photo/#{photo_id}?isthirdpartyphotoid=1"
      HTTParty.delete(url, headers: headers)
    end
    @amount = @photos.count
  end

  def add_backgrounds
    @photos = get_photos(params[:type]).processed
    new_not_bg = @photos.processed.backgrounds.where.not(id: @photo_ids)
    new_bg = @photos.where.not(background: true).where(id: @photo_ids)
    @changed_photo_ids = new_not_bg.pluck(:id)+new_bg.pluck(:id)
    @changed_photos = @event.photos.processed.where(id: @changed_photo_ids)
    new_not_bg.update_all(background: false)
    new_bg.update_all(background: true)
    # PhotosSyncWorker.perform_async(@changed_photo_ids) unless Rails.env=="development"
    @photos = @photos.where(id: @photo_ids)
    @amount = @photos.count
  end

  def post_service
    if admin_signed_in?
      url = ApiUrlHelper.api_url "/faceush/api/match.svc/cacheevent"
      body = {EventId: @event.id, UserId: @event.photographer.id, IsReload: true }.to_json
      response = HTTParty.post(url, headers: HEADERS, body: body)
      flash[:notice] = response["IsError"]==false ? "Event cache cleared" : "Error: #{response["ErrorMessage"]}"
    else
      flash[:alert] = 'You are not admin!'
    end
    redirect_to event_path(@event)
  end

  # def publish
  #   published = false
  #   unless @event.is_published
  #     @event.update(is_published: true)
  #     published = true
  #   end
  #   render 'events/publish', locals: {published: published}
  # end

  def photo_dup
    begin
      Rails.logger.info "checking dupllicate: #{params[:name]}"
      @photo = @event.photos.find_by(original_filename: params[:name], time_stamp: params[:date])
      respond_to do |f|
        f.json {render json: @photo.present?}
      end
    rescue => e
      Rails.logger.error { "error checking duplicate: #{handle}, #{e.message} #{e.backtrace.join("\n")}" }
    end
  end

  def add_tag
    @tag = params[:tag]
    exist_tag = @event.tag_list.include?(@tag)
    unless exist_tag
      @event.tag_list.add(@tag)
      @count = @event.photos.tagged_with(@tag).count
      @event.save
    end
  end

  def set_backgrounds
    photos = @event.photos.processed
    unless photos.backgrounds.blank?
      render json: true, status: "200"
      return
    end
    url = ApiUrlHelper.api_url_eb "/event/#{params[:event_id]}?additionalfields=cover_photos"
    response = HTTParty.get(url, headers: { 'Content-Type' => 'application/json; charset=UTF-8', 'Accept' => 'application/json' })
    if response.code/100 == 2
      urls = response['CoverPhotos'].map{|p| "%#{p['Url']}%"}
      photos.where("img ILIKE ANY ( array[?] )", urls).update_all(background: true)
      render json: {covers_count: photos.backgrounds.count}, status: "200"
    else
      render json: false, status: "500"
    end
  end

  private

  def event_params
    params[:event][:date] = Date.strptime(params[:event][:date], "%d.%m.%Y") if params[:event][:date].present?
    params.require(:event).permit(:name, :date, :event_type, :description, :guests, :share_message)
  end

  def event_translation_params(hsh)
    hsh.permit(:name,:description,:event_type,:place)
  end

  def event_id
    super || params[:id]
  end

  def normal_url
    if request.path != url_for(only_path: true)
      redirect_to url_for, status: :moved_permanently
    end
  end

  def photo_ids
    @photo_ids = params[:photos_hidden].split(',').map(&:to_i)
    if params[:exclude]=='true'
      @photo_ids = @event.photos.pluck(:id)-@photo_ids
    end
  end
end
