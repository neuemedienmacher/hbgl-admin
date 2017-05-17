# frozen_string_literal: true
module API::V1
  module UserTeam
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :user_teams

        attributes do
          property :name
          property :classification
          property :parent_id
          property :user_ids
        end

        has_one :parent do
          type :user_teams

          attributes do
            property :name, as: :label
          end
        end

        has_many :children do
          type :user_teams

          attributes do
            property :name, as: :label
          end
        end

        has_many :users, class: ::User do
          type :users

          attributes do
            property :name
            property :name, as: :label
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
    end
  end
end
