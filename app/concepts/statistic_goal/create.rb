# frozen_string_literal: true

class StatisticGoal::Create < Trailblazer::Operation
  step Model(::StatisticGoal, :new)
  # policy ::StatisticGoalPolicy, :create?

  step Contract::Build()
  step Contract::Validate()
  step Contract::Persist()

  extend Contract::DSL
  contract do
    property :starts_at
    property :amount

    validates :starts_at, presence: true
    validates :amount, presence: true
  end
end
