# frozen_string_literal: true
module API::V1
  module UserTeam
    module Representer
      class Show < API::V1::Default::Representer::Show
        type :user_teams

        property :name
        property :classification
        property :parent_id

        has_one :parent do
          type :user_teams
          property :id
          property :name, as: :label
        end

        has_many :children do
          type :user_teams
          property :id
          property :name, as: :label
        end

        property :user_ids # KK: Not sure if this is the best way...
        has_many :users do
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
