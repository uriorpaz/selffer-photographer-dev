module TranslationService
  extend self

  def get_attributes(*models)
    models.inject({}) do |res, model|
      bad_attrs = ['id']
      bad_attr_ends = ['_id', '_at', '_ip', '_token', '_password']
      attrs = model.nil? ? {} : model.attributes
      attrs.reject! do |k|
        bad_attrs.include?(k) || k.end_with?(*bad_attr_ends)
      end
      if model.is_a?(Event)
        trans_attrs = ["event_type", "description", "place",
                       "pre_text", "long_description", "name"]
        t = model.event_translations.find_by_lang(I18n.locale)
        if t.nil?
          attrs['date'] = model.pretty_date
        else
          translation = t.attributes
          translation_add = model.event_translations.where.not(id: t.id).first
          translation.merge!(translation_add.attributes) {|k, old_v, new_v| old_v.blank? ? new_v : old_v} unless translation_add.nil?
          attrs.merge! translation.slice(*trans_attrs)
          attrs['type'] = attrs.delete('event_type')
        end
      end
      model_name = model.class.name.downcase
      res.merge! attrs.map{|k,v| ["#{model_name}_#{k}".to_sym, v]}.to_h
    end
  end
end