# frozen_string_literal: true
class ContactPersonTranslation::Create < Trailblazer::Operation
  include Assignable::CommonSideEffects::CreateNewAssignment

  step Model(::ContactPersonTranslation, :new)

  step Contract::Build()
  step Contract::Validate()
  step Contract::Persist()
  step :create_initial_assignment!

  extend Contract::DSL
  contract do
    property :responsibility
    property :source
    property :locale
    property :contact_person_id
  end
end
