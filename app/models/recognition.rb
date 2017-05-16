class Recognition < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug, use: [:slugged, :finders]
  belongs_to :user
  belongs_to :event
  has_many :recognition_photos, -> { order "confidence desc" }, :dependent => :destroy
  has_many :photos, through: :recognition_photos
end
