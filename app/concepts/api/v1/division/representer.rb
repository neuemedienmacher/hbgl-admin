# frozen_string_literal: true
module API::V1
  module Division
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :divisions
        include API::V1::Assignable::Representer

        attributes do
          property :label, getter: ->(division) do
            "#{division[:represented].name} (#{division[:represented].size})"
          end

          property :name
          property :comment
          property :size

          property :website_ids

          property :organization_id
          property :section_id
        end

        has_one :organization, class: ::Organization do
          type :organizations

          attributes do
            property :name, as: :label
          end
        end

        has_one :section, class: ::Section,
                          populator: API::V1::Lib::Populators::Find do
          type :sections

          attributes do
            property :identifier, as: :label
          end
        end

        has_many :presumed_categories, class: ::Category do
          type :categories

          attributes do
            property :name_de, as: :label
          end
        end

        has_many :presumed_solution_categories, class: ::SolutionCategory do
          type :solution_categories

          attributes do
            property :name, as: :label
          end
        end

        has_many :websites, class: ::Website,
                            populator: API::V1::Lib::Populators::FindOrInstantiate,
                            decorator: API::V1::Website::Representer::Show
      end
    end
  end
end
