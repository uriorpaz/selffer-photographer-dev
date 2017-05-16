class Authentication < ActiveRecord::Base
  include Concerns::OmniauthConcern
  include Concerns::UserImagesConcern
  include Concerns::AuthenticationProvidersConcern

  belongs_to :user
  validates :provider, :proid, presence: true

end
