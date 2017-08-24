# frozen_string_literal: true
class Definition::Create < Trailblazer::Operation
  step Model(::Definition, :new)
  step Policy::Pundit(DefinitionPolicy, :create?)

  step Contract::Build(constant: Definition::Contracts::Create)
  step Contract::Validate()
  step Contract::Persist()
end
