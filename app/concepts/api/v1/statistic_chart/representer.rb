# frozen_string_literal: true
module API::V1
  module StatisticChart
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :statistic_charts

        attributes do
          property :label, getter: ->(pg) do
            "##{pg[:represented].id} #{pg[:represented].title}"
          end
          property :title
          property :starts_at
          property :ends_at
          property :user_id

          property :statistic_transition_ids
          property :statistic_goal_ids
        end

        has_many :statistic_transitions do
          type :statistic_transitions

          attributes do
            property :klass_name
            property :field_name
            property :start_value
            property :end_value
          end
        end

        has_many :statistic_goals do
          type :statistic_goals

          attributes do
            property :id
            property :amount
            property :starts_at
          end
        end
      end
    end
  end
end
