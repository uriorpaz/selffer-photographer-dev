class Share < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug, use: [:slugged, :finders]
  has_many :photos_shares
  has_many :photos, through: :photos_shares
end
