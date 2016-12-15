# frozen_string_literal: true
module API::V1
  module Assignable
    module Representer
      class Show < API::V1::Default::Representer::Show
        # method (uses scopes) to get current_assignment
        property :current_assignment, getter: ->(item) do
          item[:represented].current_assignment
        end

        collection :assignments do
          property :id
          property :message, as: :label
          property :creator_id
          property :creator_team_id
          property :reciever_id
          property :reciever_team_id
        end
      end

      class Index < Show
      end
    end
  end
end
