# frozen_string_literal: true

class StatisticTransition::Create < Trailblazer::Operation
  step Model(::StatisticTransition, :new)
  # policy ::StatisticTransitionPolicy, :create?

  step Contract::Build()
  step Contract::Validate()
  step Contract::Persist()

  extend Contract::DSL
  contract do
    property :klass_name
    property :field_name
    property :start_value
    property :end_value

    validates :klass_name, presence: true
    validates :field_name, presence: true
    validates :start_value, presence: true
    validates :end_value, presence: true
  end
end
