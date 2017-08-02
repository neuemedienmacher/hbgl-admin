# frozen_string_literal: true
module API::V1
  module Assignment
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :assignments
        include API::V1::Lib::JsonapiWithPolymorphy

        attributes do
          property :assignable_id
          property :assignable_type
          property :assignable_field_type
          property :creator_id
          property :creator_team_id
          property :receiver_id
          property :receiver_team_id
          property :message
          property :parent_id
          property :aasm_state
          property :created_at
          property :updated_at
          property :topic
          property :created_by_system
        end

        has_one :creator, class: ::User do
          type :users

          attributes do
            property :label, getter: ->(o) { o[:represented].name }
            property :name
          end
        end

        has_one :receiver, class: ::User do
          type :users

          attributes do
            property :label, getter: ->(o) { o[:represented].name }
            property :name
          end
        end

        has_one :creator_team, class: ::UserTeam do
          type :user_teams

          attributes do
            property :label, getter: ->(o) { o[:represented].name }
            property :name
          end
        end

        has_one :receiver_team, class: ::UserTeam do
          type :user_teams

          attributes do
            property :label, getter: ->(o) { o[:represented].name }
            property :name
          end
        end

        has_one :assignable do
          type :polymorphic
          # Above is technically incorrect. Wish the following would work ...
          # as[:represented].assignable_type.tableize.to_sym
          # property :type , getter: ->(object) do
          #   object[:represented].class.table_name.dasherize
          # end

          attributes do
            property :created_at
            property :label, getter: ->(object) do
              # TODO: This spaghetti code needs to be somewhere else
              if object[:represented].class.to_s.include?('Translation')
                if object[:represented].respond_to?(:organization)
                  object[:represented].organization.description
                elsif object[:represented].respond_to?(:contact_person)
                  object[:represented].contact_person.responsibility
                else
                  object[:represented].offer.name
                end
              elsif object[:represented].respond_to?(:display_name)
                object[:represented].display_name
              elsif object[:represented].respond_to?(:name)
                object[:represented].name
              else # create a generic label that works for any model
                "#{object[:represented].class.name}##{object[:represented].id}"
              end
            end
          end
        end
      end

      class Index < Show
      end
    end
  end
end
