class FaceImage < ActiveRecord::Base
  belongs_to :user, inverse_of: :face_images
  mount_uploader :image, PhotoUploader

  validates :image, presence: true

  include Rails.application.routes.url_helpers

  def to_jq_upload
    {
      "name" => read_attribute(:image),
      "size" => image.size,
      "url" => image.url,
      "thumbnail_url" => image.thumb.url,
      "delete_url" => face_image_path(:id => id),
      "delete_type" => "DELETE",
      "user_id" => user.id
    }
  end  
end
