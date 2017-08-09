# frozen_string_literal: true
class FederalState::Create < Trailblazer::Operation
  step Model(::FederalState, :new)
  step Policy::Pundit(FederalStatePolicy, :create?)

  step Contract::Build(constant: FederalState::Contracts::Create)
  step Contract::Validate()
  step Contract::Persist()
end
