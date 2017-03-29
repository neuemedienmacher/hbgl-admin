# frozen_string_literal: true
module API::V1
  module UserTeam
    module Representer
      class Show < API::V1::Default::Representer::Show
        type :user_teams

        property :name
        property :classification

        property :user_ids # KK: Not sure if this is the best way...
        collection :users do
          property :id
          property :name
          property :name, as: :label
        end

        # collection :created_assignments do
        #   property :id
        #   property :message, as: :label
        # end
        #
        # collection :received_assignments do
        #   property :id
        #   property :message, as: :label
        # end
      end

      # class Show < API::V1::Default::Representer::Show
      #   # items extend: Show
      # end
    end
  end
end
