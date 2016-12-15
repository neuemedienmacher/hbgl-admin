class TranslationGenerationWorker
  include Sidekiq::Worker

  def perform locale, object_type, object_id, fields = :all
    object = object_type.constantize.find(object_id)
    # get existing or newly created translation
    translation =
      API::V1::BaseTranslation::DynamicFind.new(locale, object_type, object_id)
        .find_or_create()

    # REFACTORING: move this logic and all private methods to the operation
    # build hash of fields to change
    changes_hash =
      if translation.manually_edited?
        # Translation was already edited by a human, so it is not updated with
        # a new translation but flagged as possibly outdated
        {possibly_outdated: true}
      else
        generate_field_translations(object, locale, fields)
      end
    # call operation to save the changes and create new assignment if required
    API::V1::BaseTranslation::Update.new(translation, object, changes_hash)
      .update_and_assign()
    # reindex the object (only offers)
    reindex object
    # side-effect: invoke translation logic on associated organizations
    notify_associated_organizations object
  end

  private

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

  # Site-Effect: iterate organizations and create assignments for translations.
  # Applies the entire logic (assigns only when needed) via operation.
  def notify_associated_organizations object
    return unless object.is_a?(Offer) && object.approved?
    object.organizations.approved.each do |orga|
      orga.translations.each do |translation|
        # directly call process method (assignable) for orga_translation to
        # invoke assignment logic (does not trigger new translaton)
        API::V1::BaseTranslation::Update.new(translation, orga, nil).process(nil)
      end
    end
  end
end
