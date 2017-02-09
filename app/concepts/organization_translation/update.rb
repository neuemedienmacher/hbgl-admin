# frozen_string_literal: true
class OrganizationTranslation::Update < Trailblazer::Operation
  include Translation::CommonSideEffects::HumanChangeFields
  include Assignable::CommonSideEffects::CreateNewAssignment

  step Model(::OrganizationTranslation, :find_by)

  step Contract::Build()
  step Contract::Validate()
  step :reset_source_and_possibly_outdated_if_changes_by_human
  step Contract::Persist()
  step :create_new_assignment_if_assignable_should_be_reassigned!

  extend Contract::DSL
  contract do
    property :description
    property :source
    property :possibly_outdated
  end
end
