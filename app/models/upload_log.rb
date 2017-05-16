class UploadLog < ActiveRecord::Base
  belongs_to :event
  has_many :error_logs, dependent: :destroy

  after_update :send_email

  def send_email
    event.invites.where(code: nil).each(&:send_code) if end_at_changed?(from: nil)
  end

end
