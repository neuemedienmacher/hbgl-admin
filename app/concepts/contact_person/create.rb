# frozen_string_literal: true
class ContactPerson::Create < Trailblazer::Operation
  step Model(::ContactPerson, :new)
  step Policy::Pundit(PermissivePolicy, :create?)

  step Contract::Build(constant: ContactPerson::Contracts::Create)
  step Contract::Validate()
  step Wrap(::Lib::Transaction) {
    step ::Lib::Macros::Nested::Find(:organization, ::Organization)
    step ::Lib::Macros::Nested::Create(:email, ::Email::Create)
  }
  step Contract::Persist()
end
