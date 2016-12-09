# frozen_string_literal: true
module API::V1
  module Assignment
    module Representer
      class Show < API::V1::Default::Representer::Show
        type :assignments

        property :assignable_id
        property :assignable_type
        property :assignable_field_type
        property :creator_id
        property :creator_team_id
        property :reciever_id
        property :reciever_team_id
        property :message
        property :parent_id
        property :aasm_state
        property :created_at
        property :updated_at

        has_one :creator do
          type :users

          property :id
          property :name
        end

        has_one :assignable do
          type do |as|
            as[:represented].assignable_type.underscore.pluralize.to_sym
          end

          property :id
          property :created_at
          # INFO: this won't work for any assignable model
          property :label, getter: ->(ot) do
            ot[:represented].respond_to?(:untranslated_name) ?
              ot[:represented].untranslated_name :
              ot[:represented].untranslated_description
          end
        end
      end
    end
  end
end
