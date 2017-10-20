# frozen_string_literal: true

class Tag::Create < Trailblazer::Operation
  step Model(::Tag, :new)
  step Policy::Pundit(PermissivePolicy, :create?)

  step Contract::Build(constant: Tag::Contracts::Create)
  step Contract::Validate()
  step Contract::Persist()
end
