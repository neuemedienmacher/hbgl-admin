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
        property :receiver_id
        property :receiver_team_id
        property :message
        property :parent_id
        property :aasm_state
        property :created_at
        property :updated_at
        property :topic
        property :created_by_system

        has_one :creator do
          type :users

          property :id
          property :name
        end

        has_one :assignable do
          type :assignable_type
          # Above is technically incorrect. Wish the following would work ...
          # as[:represented].assignable_type.tableize.to_sym

          property :id
          property :created_at
          property :label, getter: ->(object) do
            if object[:represented].class.to_s.include?('Translation')
              if object[:represented].respond_to?(:organization)
                object[:represented].organization.untranslated_description
              elsif object[:represented].respond_to?(:contact_person)
                object[:represented].contact_person.untranslated_responsibility
              else
                object[:represented].offer.untranslated_name
              end
            elsif object[:represented].respond_to?(:name)
              object[:represented].name
            else # create a generic label that works for any model
              "#{object[:represented].class.name}##{object[:represented].id}"
            end
          end
        end
      end
    end
  end
end
