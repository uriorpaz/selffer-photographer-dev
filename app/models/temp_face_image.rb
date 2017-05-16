class  TempFaceImage < ActiveRecord::Base
  belongs_to :temp_recognition, inverse_of: :temp_face_images
  mount_uploader :image, PhotoUploader
  has_one :event, through: :temp_recognition
  validates :image, presence: true

  include Rails.application.routes.url_helpers

  def to_jq_upload
    {
      "name" => read_attribute(:image),
      "size" => image.size,
      "url" => image.url,
      "thumbnail_url" => image.thumb.url,
      "delete_url" => temp_face_image_path(:id => id),
      "delete_type" => "DELETE",
      "temp_recognition_id" => temp_recognition.id
    }
  end
end
