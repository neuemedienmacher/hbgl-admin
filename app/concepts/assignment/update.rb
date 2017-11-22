# frozen_string_literal: true

class Assignment::Update < Trailblazer::Operation
  step Model(::Assignment, :find_by)

  step Policy::Pundit(::AssignmentPolicy, :update?)

  step Contract::Build(constant: Assignment::Contracts::Update)
  step Contract::Validate()
  step Contract::Persist()
  step ::Lib::Macros::Live::SendChanges()
end
