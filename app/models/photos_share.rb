class PhotosShare < ActiveRecord::Base
  belongs_to :photo
  belongs_to :share
end