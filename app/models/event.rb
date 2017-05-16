class Event < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders, :history]
  acts_as_taggable

  belongs_to :photographer
  belongs_to :watermark_portrait, class_name: "Watermark"
  belongs_to :watermark_landscape, class_name: "Watermark"
  has_many :photos, dependent: :destroy
  has_many :event_translations, dependent: :destroy
  has_many :invites, dependent: :destroy
  has_many :users, through: :invites, foreign_key: :event_id
  has_many :guest_invites, dependent: :destroy
  has_many :upload_logs, dependent: :destroy
  has_many :archives, dependent: :destroy
  # scope :empty, ->{ where(name: nil, date: nil, photos_count: nil, guests: nil) }
  scope :not_empty, ->{ where.not('name is null and date is null and photos_count is null and guests is null') }
  scope :not_deleted, ->{where.not(status: 1)}
  after_save :name_translate_change, if: :name_changed?
  before_update :set_default_name_and_date, if: :name_or_date_blank?
  before_update :service_new_event
  before_save :encrypt_password, if: :password_changed?
  before_save :check_password, if: :password_changed?

  enum status: [:normal, :deleted]

  HEADERS = { 'Content-Type' => 'application/json; charset=UTF-8', 'Accept' => 'application/json' }

  def background_or_photo
    self.photos.order(background: :desc).first_or_initialize
  end

  def decorate_date
    date.strftime('%d.%m.%Y') if date
  end

  def slug_candidates
    [[:name, :pretty_date]]
  end

  def pretty_date
    date ? date.strftime("%e-%m-%y").strip : ''
  end

  def should_generate_new_friendly_id?
    new_record? || ((name_changed? ||  date_changed? || id_changed?) && self.name.present? && self.date.present?) || super
  end

  def get_translated(field, lang)
    event_translations.find_by_lang(lang).try(field)
  end

  def long_id
    length_id = 6-self.id.to_s.size
    length_id<0 ? self.id : '0'*length_id+self.id.to_s
  end

  def photo_slug
    "#{long_id}#{self.slugs.order(:created_at).last.slug[6..-1]}"
  end

  def default_message
    "The photos from #{name} from #{date.strftime("%B %d %Y")} are ready! Press here to see your photos ${link}"
  end

  def share_message
    super || default_message
  end

  def encrypt_password
    unless password.nil?
      self.password = Base64.encode64(self.password)
    end
  end

  def check_password
    if self.password == nil && Event.find(self.id).password !=nil
      self.password = Event.find(self.id).password
    end
  end

  def name_or_date_blank?
    self.name.blank? || self.date.blank?
  end

  def name_for_service
    en_name = event_translations.find_or_create_by(lang: 'en').name.presence
    he_name = event_translations.find_or_create_by(lang: 'he').name.presence
    en_name || he_name || name
  end


  private

  def name_translate_change
    e_tr = self.event_translations.find_or_create_by(lang: 'en') do |e_t|
      e_t.name = self.name
    end
    e_tr.update(name: self.name) if e_tr.name!=self.name
  end

  def service_new_event
    if name_changed?(from: nil)
      url = ApiUrlHelper.api_url_eb "/event/new"
      body = {'EventSlug' => self.slugs.order(:created_at).last.slug,
              'EventName' => name, # use translations - name_for_service
              'NeedsModeration' => needs_moderation,
              'AllowNotifications' => false}.to_json
      @response = HTTParty.post(url, headers: HEADERS, body: body)
      @response.code/100==2 && @response['Success']
      self.id = @response["EventId"]
      self.slugs.each do |f| f.update_attribute(:sluggable_id, self.id) end
    else
      url = ApiUrlHelper.api_url_eb "/event/#{self.id}"
      body = {'EventName' => name, # use translations - name_for_service
              'NeedsModeration' => needs_moderation,
              'AllowNotifications' => send_notification}.to_json
      @response = HTTParty.put(url, headers: HEADERS, body: body)
      @response.code/100==2 && @response['Success']
    end
  rescue
    return false
  end

  def set_default_name_and_date
    self.slug = nil
    if self.name.blank?
      default_name = "event no name"
      self.name = default_name
      while Event.find_by_name self.name
        event_number = event_number ? event_number+1 : 2
        self.name = "#{default_name} #{event_number}"
      end
    end
    self.date = Time.now if self.date.blank?
  end
end
