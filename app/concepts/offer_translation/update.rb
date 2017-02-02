# frozen_string_literal: true
class OfferTranslation::Update < Trailblazer::Operation
  include Translation::CommonSideEffects::HumanChangeFields

  step Model(::OfferTranslation, :find_by)
  # TODO: Either make policy more useful or remove
  step Policy::Pundit(OfferTranslationPolicy, :update?)

  step Contract::Build()
  step Contract::Validate()
  step :reset_source_and_possibly_outdated_if_changes_by_human
  step Contract::Persist()
  step :reindex_offer

  extend Contract::DSL
  contract do
    property :name
    property :description
    property :opening_specification
    property :source
    property :possibly_outdated
  end

  def reindex_offer(*, model:, **)
    model.offer.reload.algolia_index!
    true
  end
end
