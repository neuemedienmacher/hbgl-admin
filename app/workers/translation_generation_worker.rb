class TranslationGenerationWorker
  include Sidekiq::Worker

  def perform locale, object_type, object_id, fields = :all
    object = object_type.constantize.find(object_id)
    translation = find_or_initialize_translation(locale, object_type, object_id)

    if translation.manually_edited?
      # Translation was already edited by a human, so it is not updated with
      # a new translation but flagged as possibly outdated
      translation.possibly_outdated = true
    else
      translation.assign_attributes(
        generate_field_translations(object, locale, fields)
      )
    end
    translation.save!
    reindex object
  end

  private

  def find_or_initialize_translation locale, object_type, object_id
    translation_class = "#{object_type}Translation".constantize
    object_id_field = "#{object_type.downcase}_id"

    # return existing translation if one is found
    translation =
      translation_class.find_by locale: locale, object_id_field => object_id
    return translation if translation

    # otherwise create a new one
    translation_class.new(
      locale: locale,
      object_id_field => object_id
    )
  end

  def generate_field_translations object, locale, fields
    translations_hash = direct_translate_to_html object, locale, fields

    if locale.to_sym == :de
      translations_hash['source'] = 'researcher'
    else
      translations_hash =
        GoogleTranslateCommunicator.get_translations translations_hash, locale
      translations_hash['source'] = 'GoogleTranslate'
    end

    translations_hash
  end

  def direct_translate_to_html object, locale, fields
    translations_hash = {}
    fields_to_translate =
      (fields.to_s == 'all') ? object.translated_fields : fields

    fields_to_translate.each do |field|
      translations_hash[field] =
        direct_translate_via_strategy(object, field, locale)
    end

    translations_hash
  end

  def direct_translate_via_strategy object, field, locale = :de
    case field.to_sym
    when :name
      object.untranslated_name
    when :description
      output = MarkdownRenderer.render(object.untranslated_description)
      output = Definition.infuse(output) if locale.to_sym == :de
      output
    when :old_next_steps, :opening_specification
      MarkdownRenderer.render object.send("untranslated_#{field}")
    else
      raise "TranslationGenerationWorker: #{field} needs translation strategy"
    end
  end

  def reindex object
    return unless object.is_a? Offer
    object.reload.algolia_index!
  end
end
