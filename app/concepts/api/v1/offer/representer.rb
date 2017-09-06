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
          property :opening_specification
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
          property :target_audience
          property :aasm_state
          property :hide_contact_people
          property :code_word
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

        link(:preview) do
          ::RemoteShow.build_preview_link(
            :angebote, represented.section.identifier, represented
          )
        end
      end

      class Index < Show
      end

      class Create < Show
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
