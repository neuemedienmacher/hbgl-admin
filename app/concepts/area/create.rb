# frozen_string_literal: true

class Area::Create < Trailblazer::Operation
  step Model(::Area, :new)
  step Policy::Pundit(PermissivePolicy, :create?)

  step Contract::Build(constant: Area::Contracts::Create)
  step Contract::Validate()
  step Contract::Persist()
end
