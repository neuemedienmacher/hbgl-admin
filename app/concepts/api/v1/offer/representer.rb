# frozen_string_literal: true
module API::V1
  module Offer
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :offers

        attributes do
          property :label, getter: ->(offer) do
            offer[:represented].untranslated_name
          end
          property :name, getter: ->(offer) do
            offer[:represented].untranslated_name
          end
          property :description, getter: ->(offer) do
            offer[:represented].untranslated_description
          end
          property :old_next_steps, getter: ->(offer) do
            offer[:represented].untranslated_old_next_steps
          end
          property :opening_specification, getter: ->(offer) do
            offer[:represented].untranslated_opening_specification
          end

          property :encounter
          property :slug
          property :created_at
          property :updated_at
          property :approved_at
          property :created_by
          property :approved_by
          property :expires_at
          property :description_html
          property :next_steps_html
          property :opening_specification_html
          property :age_from
          property :age_to
          property :target_audience
          property :aasm_state
          property :hide_contact_people
          property :age_visible
          property :code_word
          property :gender_first_part_of_stamp
          property :gender_second_part_of_stamp
          property :all_inclusive
          property :starts_at
          property :completed_at
          property :completed_by

          property :section_id
          property :logic_version_id
          property :split_base_id
          property :solution_category_id
          property :location_id
          property :area_id
        end

        has_one :section do
          type :sections

          attributes do
            property :label, getter: ->(o) { o[:represented].identifier }
            property :name
            property :identifier
          end
        end
      end

      class Index < Show
      end

      class Create < Show
        attributes do
          property :name
          property :description
          property :old_next_steps
          property :opening_specification
        end

        has_many :organizations do
          type :organizations

          attributes do
            property :name, as: :label
          end
        end

        has_many :target_audience_filters do
          type :filters

          attributes do
            property :name, as: :label
          end
        end
      end
    end
  end
end
