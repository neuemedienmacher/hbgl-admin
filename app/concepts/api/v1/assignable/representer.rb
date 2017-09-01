# frozen_string_literal: true
module API::V1
  module Assignable
    module Representer
      # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      def self.included(base)
        base.attributes do
          # method (uses scopes) to get current_assignment
          property :current_assignment_id, getter: ->(item) do
            item[:represented].current_assignment&.id
          end
          property :assignment_ids
        end

        base.has_one :current_assignment do
          type :assignments

          attributes do
            property :label, getter: ->(o) { o[:represented].message }
            property :message
            property :assignable_id
            property :assignable_type
            property :creator_id
            property :creator_team_id
            property :receiver_id
            property :receiver_team_id
            property :topic
          end

          has_one :receiver do
            type :users

            attributes do
              property :name
              property :label, getter: ->(o) { o[:represented].name }
            end
          end

          has_one :receiver_team do
            type :user_teams

            attributes do
              property :name
              property :label, getter: ->(o) { o[:represented].name }
            end
          end
        end

        base.has_many :assignments, class: ::Assignment do
          type :assignments

          attributes do
            property :message
            property :label, getter: ->(item) { item[:represented].message }
            property :creator_id
            property :creator_team_id
            property :receiver_id
            property :receiver_team_id
            property :assignable_id
            property :assignable_type
            property :assignable_field_type
            property :aasm_state
            property :parent_id
            property :created_at
            property :updated_at
            property :topic
            property :created_by_system
          end
        end
      end
      # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
    end
  end
end
