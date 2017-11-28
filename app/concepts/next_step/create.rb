# frozen_string_literal: true

class NextStep::Create < Trailblazer::Operation
  step Model(::NextStep, :new)
  step Policy::Pundit(PermissivePolicy, :create?)

  step Contract::Build(constant: NextStep::Contracts::Create)
  step Contract::Validate()
  step Contract::Persist()
end
