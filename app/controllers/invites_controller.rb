class InvitesController < ApplicationController
  skip_before_action :authenticate_any!, only: :show
  before_action :find_event, except: :show
  before_action :find_photographer

  def index
    @invites = @event.invites
  end

  def create
    @invite = @event.invites.build(invite_params)
    if @invite.save
      photos = @event.photos.processed
      headers = { 'Content-Type' => 'application/json; charset=UTF-8', 'Accept' => 'application/json' }
      published = false
      unless @event.is_published
        @event.update(is_published: true)
        if photos.backgrounds.blank?
          url = ApiUrlHelper.api_url_eb "/event/#{@event.id}"
           body = { 'EventName' =>"#{@event.name}",
                    'NeedsModeration' => true,
                    'IsPublished' => true,
                    'AllowNotifications' => false,
                    'ShouldReturnCoverPhotos'=> true }.to_json
          response = HTTParty.put(url, headers: headers, body: body)
          if response.code/100 == 2
            urls = response['CoverPhotos'].map{|p| "%#{p['Url']}%"}
            photos.where("img ILIKE ANY ( array[?] )", urls).each{|p| p.update(background: true)}
            @covers = photos.backgrounds.count
          end
        else
          url = ApiUrlHelper.api_url_eb "/event/#{@event.id}"
          body = { 'EventName' =>"#{@event.name}",
                    'NeedsModeration' => true,
                    'IsPublished' => true,
                    'AllowNotifications' => false,
                    'ShouldReturnCoverPhotos'=> false,
                    'IsPublished'=> true }.to_json
          HTTParty.put(url, headers: headers, body: body)
        end
        published = true
      end
      if @event.upload_logs.last && @event.upload_logs.last.end_at
        @invite.send_code
      end
    else
      @error = @invite.errors.first.join(' ')
    end
      render 'invites/create', locals: {published: published}
  end

  def destroy
    @invite = @event.invites.find(params[:id]).destroy
    flash[:notice] = "User #{@invite.invited_email} don't have access now"
    # redirect_to event_path(@event)
  end

  def show
    @event = Event.find event_id
    @invite = @event.invites.find_by_code(params[:id])
    flash[:error] = "wrong invite code" unless @invite
    unless current_photographer
      redirect_to new_photographer_session_path unless @invite
      cookies[:invite_code]=@invite.code
      @email = @invite.invited_email
      redirect_to new_photographer_session_path(email: @email)
    else
      redirect_to photographer_events_path(current_photographer) unless @invite
      if  @invite.invited_email==current_photographer.email
        @invite.update(invited_id: current_photographer.id, code: nil)
        flash[:notice] = "Event succesfully added"
        redirect_to event_path(@invite.event) if current_photographer.shared_events.count==1
      else
        flash[:error] = "wrong invited email"
      end
      redirect_to photographer_events_path(current_photographer)
    end
  end

  private
  def invite_params
    params[:invite][:invited_email].strip!
    params.require(:invite).permit(:invited_email, :invite_subject, :invite_message)
  end
end
