# frozen_string_literal: true
module API::V1
  module Assignable
    module Representer
      class Show < API::V1::Default::Representer::Show
        # method (uses scopes) to get current_assignment
        property :current_assignment, getter: ->(item) do
          ::Assignable::Twin.new(item[:represented]).current_assignment
        end # shouldnt this be `has_one`?

        has_many :assignments do
          type :assignments

          property :id
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
        end
      end

      class Index < Show
      end
    end
  end
end
