class InviteMailer < ApplicationMailer
  default from: 'photos@selffer.com'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.invite.send_invite.subject
  #
  def send_invite(invite, password=nil)
    @invite = invite
    @event = @invite.event
    @password = password
    @email = @invite.invited_email
    @photographer = @event.photographer
    @subject = @invite.invite_subject
    link_slug = Link.create(event_id: @event.id)
    unique_key = Shortener::ShortenedUrl.generate(event_path(link_slug, invited: 'true')).unique_key
    @link = (ENV['END_CLIENT_URL'] || Rails.application.secrets[:env]['END_CLIENT_URL']) + '/' +  unique_key
    mail(to: @email, subject: @subject )
  end

  def share_event(guest_invite, email)
    @guest_invite = guest_invite
    @event = @guest_invite.event
    mail(to: email)
  end
end
