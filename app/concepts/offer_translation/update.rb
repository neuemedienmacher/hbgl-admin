# frozen_string_literal: true

class OfferTranslation::Update < Trailblazer::Operation
  include Translation::CommonSideEffects::HumanChangeFields
  include Assignable::CommonSideEffects::CreateNewAssignment

  step Model(::OfferTranslation, :find_by)
  # TODO: Either make policy more useful or remove
  step Policy::Pundit(PermissivePolicy, :update?)

  step Contract::Build(constant: OfferTranslation::Contracts::Update)
  step Contract::Validate()
  step :reset_source_and_possibly_outdated_if_changes_by_human
  step Contract::Persist()
  step :reindex_offer
  step :create_new_assignment_if_assignable_should_be_reassigned!
  step :create_optional_assignment_for_organization_translation!
  step :create_new_assignment_if_save_and_close_clicked!

  def reindex_offer(*, model:, **)
    model.offer.reload.algolia_index!
    true
  end
end
