class TempRecognition < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug, use: [:slugged, :finders]

  belongs_to :event
  has_many :temp_recognition_photos, autosave: true, dependent: :destroy
  has_many :photos, through: :temp_recognition_photos
  has_many :temp_face_images, -> { uniq }, autosave: true, dependent: :destroy, inverse_of: :temp_recognition
  has_and_belongs_to_many :possible_faces
  accepts_nested_attributes_for :temp_face_images, allow_destroy: true
  accepts_nested_attributes_for :temp_recognition_photos

  validates :email, presence: true, allow_blank: false

  default_scope { order(created_at: :desc) }
  before_validation :set_name
  after_create :create_name

  def set_name
    self.slug = Digest::SHA1.hexdigest("temp_recognition_#{self.id}")
  end

  def create_name
    self.update(slug: Digest::SHA1.hexdigest("temp_recognition_#{self.id}"))
  end
end
