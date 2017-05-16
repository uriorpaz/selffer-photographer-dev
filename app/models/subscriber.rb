class Subscriber < ActiveRecord::Base
  belongs_to :event
  # has_one :recognition, autosave: true, dependent: :destroy, inverse_of: :subscriber
  # has_one :temp_recognition, autosave: true, dependent: :destroy, inverse_of: :subscriber
  # accepts_nested_attributes_for :face_images, allow_destroy: true
end
