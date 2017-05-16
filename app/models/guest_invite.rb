class GuestInvite < ActiveRecord::Base
  has_one :photographer, through: :event
  belongs_to :event
  enum status: [:not_sent, :sent, :received]
  validate :presence_any
  validates :phone, format: {with: /\A(\d|\+|\-|\.|\s)*\z/}
  validates :email, presence: false, email: true, :if => :test
  before_create :set_code

  def test
    email.present?
  end

  def get_normal_phone
    norm = phone.gsub(/[^\d]/,'')
    if (9..12).include? norm.length
      '+972'.first(13-norm.length)+norm
    end
  end

  def share(url)
    sent!
    InviteMailer.share_event(self, email).deliver_now if email
    if phone && Rails.env=="production"
      @client = Twilio::REST::Client.new Twilio_account, Twilio_auth
      body = event.share_message.gsub('${link}', url)
      @client.account.messages.create({from: '+972526284473', to: get_normal_phone, body: body})
    end
  end

  private
  def presence_any
    errors.add(:email, " and phone can't be blank") if email.blank? && phone.blank?
  end

  def set_code 
    self.code=SecureRandom.uuid
  end
end
