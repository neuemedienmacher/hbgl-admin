# frozen_string_literal: true

class LogicVersion::Create < Trailblazer::Operation
  step Model(::LogicVersion, :new)
  step Policy::Pundit(PermissivePolicy, :create?)

  step Contract::Build(constant: LogicVersion::Contracts::Create)
  step Contract::Validate()
  step Contract::Persist()
end
