# frozen_string_literal: true
module API::V1
  module Offer
    module Representer
      class Show < API::V1::Default::Representer::Show
        type :offers

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

        collection :organizations do
          property :name, as: :label
        end
        collection :section_filters do
          property :label, getter: ->(r) { r[:represented].name }
          property :name
        end
        collection :target_audience_filters do
          property :name, as: :label
        end
      end
    end
  end
end
