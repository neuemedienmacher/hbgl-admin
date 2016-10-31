# frozen_string_literal: true
module API::V1
  module UserTeam
    module Representer
      class Show < API::V1::Default::Representer::Show
        type :user_teams

        property :name

        collection :users do
          property :id
          property :name, as: :label
        end

        collection :created_assignments do
          property :id
          property :message, as: :label
        end

        collection :recieved_assignments do
          property :id
          property :message, as: :label
        end
      end

      # class Show < API::V1::Default::Representer::Show
      #   # items extend: Show
      # end
    end
  end
end
