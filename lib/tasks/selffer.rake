namespace :selffer do
  desc "Move data from event_translations to event"
  task move_translations_to_event: :environment do
    move_t(631)
  end

  def move_t(event_id)
    e = Event.find(event_id)
    t = TranslationService.get_attributes(e).map{ |k,v| [k.to_s.sub("event_", "").to_sym, v] }.to_h
    e.update(t)
  end

end
