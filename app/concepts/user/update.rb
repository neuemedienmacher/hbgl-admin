# frozen_string_literal: true
class User::Update < Trailblazer::Operation
  step Model(::User, :find_by)
  step Policy::Pundit(UserPolicy, :update?)

  step Contract::Build()
  step Contract::Validate()
  step Contract::Persist()

  extend Contract::DSL
  contract do
    property :current_team_id
    validates :current_team_id, presence: true, numericality: true
  end
end
