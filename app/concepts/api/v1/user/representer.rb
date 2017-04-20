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
        property :user_team_ids

        has_many :user_teams do
          type :user_teams

          property :id
          property :name
          property :label, getter: ->(user_team) do
            user_team[:represented].name
          end
        end

        has_many :led_teams do
          type :user_teams

          property :id
          property :name
          property :label, getter: ->(led_team) do
            led_team[:represented].name
          end
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
        property :name
        property :email
        property :role
      end
    end
  end
end
