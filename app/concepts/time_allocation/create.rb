# frozen_string_literal: true

class TimeAllocation::Create < Trailblazer::Operation
  step Model(::TimeAllocation, :new)
  step Policy::Pundit(TimeAllocationPolicy, :create?)
  step Contract::Build(constant: TimeAllocation::Contracts::Create)
  step Contract::Validate()
  step Contract::Persist()
end
