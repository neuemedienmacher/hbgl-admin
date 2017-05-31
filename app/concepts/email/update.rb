# frozen_string_literal: true
class Email::Update < Trailblazer::Operation
  step Model(::Email, :find_by)
  step Policy::Pundit(EmailPolicy, :update?)

  step Contract::Build(constant: Email::Contracts::Update)
  step Contract::Validate()
  step Contract::Persist()
end
