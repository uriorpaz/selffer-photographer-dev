class Photo < ActiveRecord::Base
  require 'fastimage'
  # enum status: [:normal, :background, :priv]
  # Photo.all.each{|p| p.background=p.background?;p.priv=p.priv?;p.save}

  acts_as_taggable
  belongs_to :event, counter_cache: true
  has_one :photographer, through: :event
  # mount_uploader :img, PhotoUploader
  # store_in_background :img, CarrierwaveServiceWorker
  validates :img, presence: true
  validates_uniqueness_of :original_filename, scope: [:time_stamp, :event_id]

  scope :likes, ->{where(like: true)}
  scope :albums, ->{where(album: true)}
  scope :backgrounds, ->{where(background: true)}
  scope :privs, ->{where(priv: true)}
  scope :processed, ->{where(is_processed: true)}
  scope :not_processed, ->{where.not(is_processed: true)}
  scope :is_show, ->{where(is_show: true)}

  def self.send_data
    all.map{|p| p.send_data }
  end

  def send_data
    {id: id, event_id: event.id}
  end

  def img_url_high
    amazon_url.downcase.gsub('/orig_images/','/high/').gsub('/low/','/high/') if img.present?
  end

  def img_url_low
    amazon_url.downcase.gsub('/orig_images/','/low/').gsub('/high/','/low/') if img.present?
  end

  def set_size
    img_s = FastImage.size(img_url_high)
    update(image_size: img_s.join('x')) if img_s
  end

  private
  def amazon_url
    url=img
    unless url.include? 's3.amazonaws.com/'
      filename = url.split('/').last
      bucket = Rails.application.secrets[:env]['S3_BUCKET_NAME']
      env = ENV['CUSTOM_ENV'] || Rails.env
      url = "https://#{bucket}.s3.amazonaws.com/selffer/#{env}/events/#{self.event.id}/pictures/orig_images"
    end
    url
  end
end
