# frozen_string_literal: true
class OfferTranslation::Update < Trailblazer::Operation
  include Translation::CommonSideEffects::HumanChangeFields
  include Assignable::CommonSideEffects::CreateNewAssignment

  step Model(::OfferTranslation, :find_by)
  # TODO: Either make policy more useful or remove
  step Policy::Pundit(OfferTranslationPolicy, :update?)

  step Contract::Build()
  step Contract::Validate()
  step :reset_source_and_possibly_outdated_if_changes_by_human
  step Contract::Persist()
  step :reindex_offer
  step :create_new_assignment_if_assignable_should_be_reassigned!
  step :create_assignment_for_organization_if_it_should_be_assigned!

  extend Contract::DSL
  contract do
    property :name
    property :description
    property :opening_specification
    property :old_next_steps
    property :source
    property :possibly_outdated
  end

  def reindex_offer(*, model:, **)
    model.offer.reload.algolia_index!
    true
  end
end
