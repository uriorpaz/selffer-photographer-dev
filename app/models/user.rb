class User < ActiveRecord::Base
  include Concerns::UserImagesConcern

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :timeoutable
  has_many :authentications, dependent: :destroy, validate: false, inverse_of: :user do
    def grouped_with_oauth
      includes(:oauth_cache).group_by {|a| a.provider }
    end
  end
  has_many :invites, foreign_key: :invited_id
  has_many :events, through: :invites
  has_many :recognitions, autosave: true, dependent: :destroy, inverse_of: :user
  has_many :face_images, autosave: true, dependent: :destroy, inverse_of: :user
  has_many :archives
  accepts_nested_attributes_for :face_images, allow_destroy: true
end
