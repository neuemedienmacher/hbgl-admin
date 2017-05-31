# frozen_string_literal: true
class ContactPerson::Create < Trailblazer::Operation
  step Model(::ContactPerson, :new)
  step Policy::Pundit(ContactPersonPolicy, :create?)

  step Contract::Build(constant: ContactPerson::Contracts::Create)
  step Contract::Validate()
  step Contract::Persist()
end
