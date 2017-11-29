# frozen_string_literal: true

class Website::Update < Trailblazer::Operation
  step Model(::Website, :find_by)
  step Policy::Pundit(PermissivePolicy, :update?)

  step Contract::Build(constant: Website::Contracts::Update)
  step Contract::Validate()
  step Contract::Persist()
  step ::Lib::Macros::Live::SendChanges()
end
