class Photographer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  extend FriendlyId
  friendly_id :studio_name, use: [:slugged, :finders]
  devise :database_authenticatable, #:registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :events
  has_many :invites, dependent: :destroy, through: :events
  has_many :incoming_invites, dependent: :destroy, class_name: Invite, foreign_key: :invited_id
  has_many :shared_events, through: :incoming_invites, source: :event
  has_many :invited, through: :invites
  has_many :inviters, through: :incoming_invites, source: :photographer
  has_many :guest_invites, dependent: :destroy, through: :events
  has_many :watermarks
  mount_uploader :logo, LogoUploader
  after_update :cut_logo, :if => :cropping?
  # after_update :sync_photographer
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h, :crop_rotate

  def cropping?
    crop_x && crop_y && crop_w && crop_h && crop_rotate
  end

  def should_generate_new_friendly_id?
    studio_name_changed? || super
  end

  private
  def sync_photographer
    PhotographerSyncWorker.perform_async(self.id) unless Rails.env=="development"
  end

  def cut_logo
    logo.manipulate! do |img|
      img.rotate crop_rotate
      img.crop "#{crop_w}x#{crop_h}+#{crop_x}+#{crop_y}"
    end
    logo.resize_to_fit(-1, ENV['PHOTOGRAPHER_LOGO_HEIGHT'] || Rails.application.secrets[:env]['PHOTOGRAPHER_LOGO_HEIGHT'])
  end
end
