# frozen_string_literal: true

class Email::Create < Trailblazer::Operation
  step Model(::Email, :new)
  step Policy::Pundit(PermissivePolicy, :create?)

  step Contract::Build(constant: Email::Contracts::Create)
  step Contract::Validate()
  step Contract::Persist()
end
