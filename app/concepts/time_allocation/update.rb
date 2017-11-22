# frozen_string_literal: true

class TimeAllocation::Update < Trailblazer::Operation
  step Model(::TimeAllocation, :find_by)
  step Policy::Pundit(TimeAllocationPolicy, :update?)
  step Contract::Build(constant: TimeAllocation::Contracts::Update)
  step Contract::Validate()
  step Contract::Persist()
  step ::Lib::Macros::Live::SendChanges()
end
