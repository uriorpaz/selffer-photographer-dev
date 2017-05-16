class ApplicationController < ActionController::Base
  include ApplicationHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :authenticate_any!

  def after_sign_in_path_for(resource)
    if resource.class==Admin
      rails_admin_path
    else
      accept_invite
      photographer_events_path(resource)
    end
  end

  def t(key, additional = {}, *models)
    hsh = TranslationService.get_attributes(*models)
    hsh.merge!(additional)
    super(key, hsh)
  end

  private
  def after_sign_out_path_for(resource_or_scope)
    new_session_path(resource_or_scope)
  end

  #application_controller.rb
  def authenticate_any!
    if admin_signed_in?
      true
    else
      authenticate_photographer!
    end
  end

  def find_event
    if admin_signed_in?
      @event = Event.find event_id
    else
      begin
        @event = current_photographer.events.not_deleted.friendly.find(event_id)
      rescue
      end
      @event ||= current_photographer.shared_events.not_deleted.friendly.find(event_id)
    end
  end

  def event_id
    params[:event_id]
  end

  def find_photographer
    if admin_signed_in?
      if @event
        @photographer = @event.photographer
      else
        if params[:photographer_id]
          id = params[:photographer_id] || params[:photographer][:id]
          @photographer = Photographer.find(id) if id
        else
          redirect_to rails_admin_path
        end
      end
    else
      @photographer = current_photographer
    end
  end

  def get_photos(type)
    case type
    when 'backgrounds'
      @event.photos.backgrounds
    when 'album'
      @event.photos.albums
    when 'like'
      @event.photos.likes
    when 'priv'
      @event.photos.privs
    when 'not_priv'
      @event.photos.where.not(priv: true)
    else
      @event.photos
    end
  end
end
