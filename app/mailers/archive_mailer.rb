class ArchiveMailer < ApplicationMailer
  default from: "no-reply@selffer.com"
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.archive_mailer.send_file.subject
  #
  def send_file(archives)
    @archives = archives
    @event = @archives.first.event
    mail(to: @archives.first.email, subject: t('photographer_client.email_with_photos_url_title', event_type: @event.get_translated(:event_type,I18n.locale), event_name: @event.get_translated(:name,I18n.locale)))
  end


  def generate_file_started(email, event)
    @event = event
    mail(to: email, subject: t('photographer_client.email_photos_url_generating_title', event_type: @event.get_translated(:event_type,I18n.locale), event_name: @event.get_translated(:name,I18n.locale)))
  end
end
