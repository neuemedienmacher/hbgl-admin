# frozen_string_literal: true
class Assignment::Update < Trailblazer::Operation
  step Model(::Assignment, :find_by)

  step Policy::Pundit(::AssignmentPolicy, :update?)

  step Contract::Build()
  step Contract::Validate()
  step Contract::Persist()

  extend Contract::DSL
  contract do
    property :assignable_id
    property :assignable_type
    property :creator_id
    property :creator_team_id
    property :receiver_id
    property :receiver_team_id
    property :message
    property :aasm_state

    validates :receiver_id, numericality: true, allow_blank: true
  end
end
