# frozen_string_literal: true
class OrganizationTranslation::Create < Trailblazer::Operation
  include Assignable::CommonSideEffects::CreateNewAssignment

  step Model(::OrganizationTranslation, :new)

  step Contract::Build()
  step Contract::Validate()
  step Contract::Persist()
  step :create_initial_assignment!

  extend Contract::DSL
  contract do
    property :description
    property :source
    property :possibly_outdated
    property :locale
    property :organization_id
  end
end
