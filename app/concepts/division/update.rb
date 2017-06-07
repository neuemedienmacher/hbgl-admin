# frozen_string_literal: true
class Division::Update < Trailblazer::Operation
  include Assignable::CommonSideEffects::CreateNewAssignment

  step Model(::Division, :find_by)
  step Policy::Pundit(DivisionPolicy, :update?)

  step Contract::Build(constant: Division::Contracts::Update)
  step Contract::Validate()
  step Contract::Persist()
  step :create_new_assignment_if_assignable_should_be_reassigned!
end
