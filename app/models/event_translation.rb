class EventTranslation < ActiveRecord::Base
  belongs_to :event
  after_save :update_event_name, if: :en?

  def en?
    lang=="en"
  end

  def to_sync
    {lang: lang, name: name, description: description, pre_text: event_type}
  end

  private
  def update_event_name
    event.update(name: self.name) if name.present? && event.name!=name
  end
end
