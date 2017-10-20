# frozen_string_literal: true

class TranslationGenerationWorker
  include Sidekiq::Worker

  def perform locale, object_type, object_id, fields = :all
    object_to_translate = object_type.constantize.find(object_id)
    Translation::AutomaticUpsert.(
      {},
      'locale' => locale,
      'object_to_translate' => object_to_translate,
      'fields' => fields
    )
  end
end
