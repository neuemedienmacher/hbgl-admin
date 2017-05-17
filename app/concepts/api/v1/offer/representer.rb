# frozen_string_literal: true
module API::V1
  module Offer
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :offers

        attributes do
          property :label, getter: ->(offer) do
            offer[:represented].name
          end
          property :name
          property :description
          property :old_next_steps
          property :encounter
          property :slug
          property :location_id
          property :created_at
          property :updated_at
          property :opening_specification
          property :approved_at
          property :created_by
          property :approved_by
          property :expires_at
          property :area_id
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
          property :solution_category_id
          property :treatment_type
          property :participant_structure
          property :gender_first_part_of_stamp
          property :gender_second_part_of_stamp
          property :logic_version_id
          property :split_base_id
          property :all_inclusive
          property :starts_at
          property :completed_at
          property :completed_by
          property :section_id
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

        has_one :section do
          type :sections

          attributes do
            property :name
            property :identifier
          end
        end
      end
    end
  end
end
