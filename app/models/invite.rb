class Invite < ActiveRecord::Base
  has_one :photographer, through: :event
  belongs_to :event
  belongs_to :invited, class_name: "Photographer"
  belongs_to :user, foreign_key: :invited_id
  validates :invited_id, uniqueness: { scope: :event_id }, if: :invited_id
  validates :invited_email, uniqueness: { scope: :event_id }, if: :invited_email
  validate :check_owner_and_invited

  def status
    code ? "Pending" : 'Received'
  end

def send_code
    event.update(is_published: true)
    code = SecureRandom.uuid
    while Invite.find_by_code(code) do
      code = SecureRandom.uuid
    end
    inv_user = User.find_by_email(self.invited_email)
    # inv_photographer = Photographer.find_by_email(self.invited_email)
    password = nil
     unless inv_user
      password = (0...8).map { (65 + rand(26)).chr }.join
      # inv_photographer = Photographer.create( email: self.invited_email,
      #                                         password: password,
      #                                         is_owner: true)
      inv_user = event.users.create( email: self.invited_email,
                                     password:  password )
    end
    self.update(code: code, invited_id: inv_user.id)
    InviteMailer.send_invite(self, password).deliver_now
  end

  #   def send_code
  #   event.update(is_published: true)
  #   code = SecureRandom.uuid
  #   while Invite.find_by_code(code) do
  #     code = SecureRandom.uuid
  #   end
  #   inv_user = User.find_by_email(self.invited_email)
  #   inv_photographer = Photographer.find_by_email(self.invited_email)
  #   password = nil
  #   unless inv_user || inv_photographer
  #     password = (0...8).map { (65 + rand(26)).chr }.join
  #     inv_user = User.create( email: self.invited_email,
  #                             password:  password )
  #     inv_photographer = Photographer.create( email: self.invited_email,
  #                                             password: password,
  #                                             is_owner: true)
  #   end
  #   self.update(code: code, invited_id: inv_photographer.id)
  #   InviteMailer.send_invite(self, password).deliver_now
  # end

  def check_owner_and_invited
    errors.add(:photographer, "can't invite himself") if invited_id == photographer.id || invited_email == photographer.email
  end

end
