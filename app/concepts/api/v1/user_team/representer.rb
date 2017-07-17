# frozen_string_literal: true
module API::V1
  module UserTeam
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :user_teams

        attributes do
          property :name
          property :classification
          property :lead_id
          property :parent_id
          property :user_ids
          property :observing_user_ids
        end

        has_one :parent, class: ::UserTeam do
          type :user_teams

          attributes do
            property :name, as: :label
          end
        end

        has_one :lead, class: ::User do
          type :users

          attributes do
            property :name, as: :label
          end
        end
      end

      class Index < Show
      end

      class Create < Show
        # has_many :children, class: ::UserTeam do
        #   type :user_teams
        #
        #   attributes do
        #     property :name, as: :label
        #   end
        # end

        has_many :users, class: ::User,
                         populator: API::V1::Lib::Populators::Find do
          type :users

          attributes do
            property :name, as: :label
            property :name
          end
        end

        has_many :observing_users, class: ::User,
                                   populator: API::V1::Lib::Populators::Find do
          type :users

          attributes do
            property :name, as: :label
            property :name
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
