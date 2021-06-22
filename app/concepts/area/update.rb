# frozen_string_literal: true

class Area::Update < Trailblazer::Operation
  step Model(::Area, :find_by)
  step Policy::Pundit(PermissivePolicy, :update?)

  step Contract::Build(constant: Area::Contracts::Update)
  step Contract::Validate()
  step Contract::Persist()
  step ::Lib::Macros::Live::SendChanges()
end
