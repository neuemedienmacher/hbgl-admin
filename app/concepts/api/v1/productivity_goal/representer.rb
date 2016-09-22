# frozen_string_literal: true
module API::V1
  module ProductivityGoal
    module Representer
      class Show < API::V1::Default::Representer::Show
        type :productivity_goals

        property :label, getter: ->(pg) do
          "##{pg[:represented].id} #{pg[:represented].title}"
        end
        property :title
        property :starts_at
        property :ends_at
        property :target_model
        property :target_count
        property :target_field_name
        property :target_field_value
        property :user_team_id
      end
    end
  end
end
