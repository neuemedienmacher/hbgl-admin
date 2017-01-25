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

  private

  # Side-Effect: iterate organizations and create assignments for translations.
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
