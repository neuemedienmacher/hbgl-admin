# frozen_string_literal: true
module Translation
  class AutomaticUpsert < Trailblazer::Operation
    # Expected options: locale, object_to_translate, fields
    step :collect_basic_params
    step :generate_translation_params
    step :call_nested_specific_update_or_create

    def collect_basic_params(options)
      options['params'] = basic_query_and_upsert_params(options)
      options['params'][:id] =
        query_for_existing_translation(options).first.try(:id)
      true
    end

    def generate_translation_params(options, params:, **)
      found_model = query_for_existing_translation(options).first

      new_params =
        if found_model && found_model.manually_edited?
          # Translation was already edited by a human, so it is not updated
          # with a new translation but flagged as possibly outdated
          {possibly_outdated: true}
        else
          generate_field_translations(options)
        end

      options['params'] = params.merge(new_params)
    end

    def call_nested_specific_update_or_create(options, params:, **)
      acting_user_options = { 'current_user' => last_acting_user(options) }
      result =
        if query_for_existing_translation(options).count > 0
          model_class(options)::Update.(params, acting_user_options)
        else
          model_class(options)::Create.(params, acting_user_options)
        end
      options['model'] = result['model']
      result.success?
    end

    # --- helper functions for inferring and querying --- #

    def basic_query_and_upsert_params(options)
      {
        locale: options['locale'],
        id_field(options) => options['object_to_translate'].id
      }
    end

    def query_for_existing_translation(options)
      model_class(options).where(basic_query_and_upsert_params(options))
    end

    def id_field(options)
      options['object_to_translate'].class.name.underscore + '_id'
    end

    def model_class(options)
      "#{options['object_to_translate'].class.name}Translation".constantize
    end

    def last_acting_user(options)
      object = options['object_to_translate']
      User.find(object.approved_by ? object.approved_by : object.created_by)
    end

    # --- Logic for automatic translations --- #

    def generate_field_translations options
      params_hash = direct_translate_to_html(options)

      if options['locale'].to_sym == :de
        params_hash[:source] = 'researcher'
      else
        params_hash = GoogleTranslateCommunicator.get_translations(
          params_hash, options['locale']
        )
        params_hash[:source] = 'GoogleTranslate'
      end

      params_hash
    end

    def direct_translate_to_html options
      params_hash = {}
      fields_to_translate = (options['fields'].to_s == 'all') ?
        options['object_to_translate'].translated_fields : options['fields']

      fields_to_translate.each do |field|
        params_hash[field] = direct_translate_via_strategy(options, field)
      end

      params_hash
    end

    def direct_translate_via_strategy options, field
      object = options['object_to_translate']
      case field.to_sym
      when :name
        object.untranslated_name
      when :description
        output = MarkdownRenderer.render(object.untranslated_description)
        output = Definition.infuse(output) if options['locale'].to_sym == :de
        output
      when :old_next_steps, :opening_specification
        MarkdownRenderer.render object.send("untranslated_#{field}")
      else
        raise "Translation::AutomaticUpsert #{field} needs translation strategy"
      end
    end
  end
end
