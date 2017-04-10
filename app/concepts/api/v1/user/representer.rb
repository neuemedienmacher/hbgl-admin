# frozen_string_literal: true
module API::V1
  module User
    module Representer
      class Show < API::V1::Default::Representer::Show
        type :users

        property :id
        property :label, getter: ->(user) do
          user[:represented].name
        end
        property :name
        property :email
        property :role
        property :current_team_id
        property :user_team_ids

        collection :user_teams do
          property :id
          property :name, as: :label
        end

        has_many :led_teams do
          type :user_teams
          property :id
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

      # class Index < API::V1::Default::Representer::Index
      #   # items extend: Show
      # end

      class Update < Roar::Decorator
        include Roar::JSON::JSONAPI
        type :users
        property :id
        property :current_team_id
      end
    end
  end
end
