# frozen_string_literal: true
class Division::Create < Trailblazer::Operation
  include Assignable::CommonSideEffects::CreateNewAssignment

  step Model(::Division, :new)
  step Policy::Pundit(DivisionPolicy, :create?)

  step Contract::Build(constant: Division::Contracts::Create)
  step Contract::Validate()
  step Contract::Persist()
  step :create_initial_assignment!
end
