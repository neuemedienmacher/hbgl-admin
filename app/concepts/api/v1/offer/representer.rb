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
        property :target_audience
        property :aasm_state
        property :hide_contact_people
        property :code_word
        property :solution_category_id
        property :logic_version_id
        property :split_base_id
        property :all_inclusive
        property :starts_at
        property :completed_at
        property :completed_by
        property :section_id

        collection :organizations do
          property :name, as: :label
        end

        collection :target_audience_filters do
          property :name, as: :label
        end

        has_one :section do
          type :sections

          property :id
          property :name
          property :identifier
        end
      end
    end
  end
end
