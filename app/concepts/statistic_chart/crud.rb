# frozen_string_literal: true
class StatisticChart < ActiveRecord::Base
  class Create < Trailblazer::Operation
    step Model(::StatisticChart, :new)

    step Policy::Pundit(::StatisticChartPolicy, :create?)

    step Contract::Build()
    step Contract::Validate()
    step Contract::Persist()

    extend Contract::DSL
    contract do
      property :title
      property :starts_at
      property :ends_at
      # property :target_model
      # property :target_count
      # property :target_field_name
      # property :target_field_value
      property :user_team_id
      property :user_id

      validates :title, presence: true
      validates :starts_at, presence: true
      validates :ends_at, presence: true
      # validates :target_model, presence: true
      # validates :target_count, presence: true
      # validates :target_field_name, presence: true
      # validates :target_field_value, presence: true
      # validates :user_team_id, presence: true
      validates :user_id, presence: true

      validate :starts_at_must_be_before_ends_at
      def starts_at_must_be_before_ends_at
        if !starts_at || !ends_at || starts_at >= ends_at
          errors.add(:starts_at, 'must be before ends_at')
        end
      end

      # TODO: validate target_field_name & _value in combination with all others
    end
  end

  class Update < Trailblazer::Operation
    step Model(StatisticChart, :update)
    step Policy::Pundit(StatisticChartPolicy, :update?)

    step Contract::Build()
    step Contract::Validate()
    step Contract::Persist()

    extend Contract::DSL
    contract do
      property :title
      # target_count
    end
  end
end
