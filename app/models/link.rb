class Link < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug, use: [:slugged, :finders]
  belongs_to :share
  after_create :create_name


  def create_name
    self.update(slug: Digest::SHA1.hexdigest("link_#{self.id}"))
  end
end
