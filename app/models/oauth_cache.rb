class OauthCache < ActiveRecord::Base
  self.primary_key = 'authentication_id'

  belongs_to :authentication, inverse_of: :oauth_cache
  validates :authentication, :data_json, presence: true
end
