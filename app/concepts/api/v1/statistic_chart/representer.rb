# frozen_string_literal: true
module API::V1
  module StatisticChart
    module Representer
      class Show < API::V1::Default::Representer::Show
        type :statistic_charts

        property :label, getter: ->(pg) do
          "##{pg[:represented].id} #{pg[:represented].title}"
        end
        property :title
        property :starts_at
        property :ends_at
        property :user_id
        property :user_team_id

        property :statistic_transition_ids
        has_many :statistic_transitions do
          type :statistic_transitions

          property :id
          property :klass_name
          property :field_name
          property :start_value
          property :end_value
        end

        property :statistic_goal_ids
        has_many :statistic_goals do
          type :statistic_goals

          property :id
          property :amount
          property :starts_at
        end
      end
    end
  end
end
