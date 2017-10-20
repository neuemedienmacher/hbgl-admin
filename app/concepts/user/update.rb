# frozen_string_literal: true

class User::Update < Trailblazer::Operation
  step Model(::User, :find_by)
  step Policy::Pundit(UserPolicy, :update?)

  step Contract::Build()
  step Contract::Validate()
  step Contract::Persist()

  extend Contract::DSL
  contract do
    property :id, writeable: false
    property :name
    validates :name, presence: true
  end
end
