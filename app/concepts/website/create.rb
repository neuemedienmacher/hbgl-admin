# frozen_string_literal: true
class Website::Create < Trailblazer::Operation
  step Model(::Website, :new)

  step Contract::Build()
  step Contract::Validate()
  step Contract::Build(constant: Website::Contracts::Create)
  step Contract::Persist()
end
