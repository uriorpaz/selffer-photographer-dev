class Archive < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  mount_uploader :file, ArchiveUploader
end
