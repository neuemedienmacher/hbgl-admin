# frozen_string_literal: true
class Organization::Create < Trailblazer::Operation
  include Assignable::CommonSideEffects::CreateNewAssignment

  step Model(::Organization, :new)
  step Policy::Pundit(OrganizationPolicy, :create?)

  step Contract::Build(constant: Organization::Contracts::Create)
  step Contract::Validate()
  step Wrap(::Lib::Transaction) {
    step ::Lib::Macros::Nested::Create :website, Website::Create
    step ::Lib::Macros::Nested::Create :divisions, Division::Create
    step ::Lib::Macros::Nested::Create :contact_people, ContactPerson::Create
    step ::Lib::Macros::Nested::Create :locations, Location::Create
    step ::Lib::Macros::Nested::Find :topics, ::Topic
  }
  step :set_creating_user
  step Contract::Persist()
  step :create_initial_assignment!

  def set_creating_user(_, current_user:, model:, **)
    model.created_by = current_user.id
  end
end
