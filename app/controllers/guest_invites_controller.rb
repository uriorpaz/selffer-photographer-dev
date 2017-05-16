class GuestInvitesController < ApplicationController
  before_action :find_event, except: :show
  skip_before_action :authenticate_any!, only: :show 

  def index
    @photographer = @event.photographer
    @guest_invites = @event.guest_invites
  end

  def create
    @guest_invite = @event.guest_invites.new(guest_invite_params)
    if @guest_invite.save
      flash[:notice] = "created invite"
    else
      flash[:alert] = @guest_invite.errors.first.join(' ')
    end
    redirect_to event_guest_invites_path(@event)
  end

  def share
    @guest_invite = @event.guest_invites.find(params[:guest_invite_id])
    @guest_invite.share(event_guest_invite_url(@event.id,@guest_invite.code))
    flash[:notice] = "invite sent"
    redirect_to event_guest_invites_path(@event)
  end

  def destroy
    @event.guest_invites.find(params[:id]).destroy
    flash[:notice] = "invite deleted"
    redirect_to event_guest_invites_path(@event)
  end

  def upload_csv
    file = open(params[:file])
    ext = File.extname(file)
    rows = []
    if ext=='.xls' || ext=='.xlsx'
      spreadsheet = ext=='.xls' ? Roo::Excel.new(file) : Roo::Excelx.new(file)
      header = spreadsheet.row(1)
      for i in 2..spreadsheet.last_row do
        r = Hash[[header, spreadsheet.row(i)].transpose].slice("email", "phone")
        r['phone'] = r['phone'].to_i if r['phone'].class==Float
        rows << r
      end
    else
      CSV.foreach(open params[:file]) do |row|
        row.delete(nil)
        row.each do |r|
          if r=~/\A(\d|\+|\-|\.|\s)*\z/
            rows << {phone: r}
          else
            rows << {email: r}
          end
        end
      end
    end
    rows.each do |row|
      @event.guest_invites.create(row)
    end
    flash[:notice] = "invites added"
    redirect_to event_guest_invites_path(@event)
  end

  def show
    @base_uri = ENV['STAGING_MAIN_SERVER_URL'] || Rails.application.secrets[:env]['MAIN_SERVER_URL']
    @event = Event.find(params[:event_id])
    @guest_invite = @event.guest_invites.find_by_code(params[:id])
    if @guest_invite
      @guest_invite.received!
      redirect_to base_uri+event_path(@event)
    else
      redirect_to base_uri
    end
  end

  private 
  def guest_invite_params
    params.require(:guest_invite).permit(:email,:phone)
  end
end