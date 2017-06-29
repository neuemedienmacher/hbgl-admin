# frozen_string_literal: true
module API::V1
  module Division
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :divisions
        include API::V1::Assignable::Representer

        attributes do
          property :label, getter: ->(division) do
            division[:represented].name
          end

          property :name
          property :comment
          property :size
          property :done

          property :website_ids

          property :organization_id
          property :section_id
          property :city_id
          property :area_id
        end

        has_one :organization, class: ::Organization do
          type :organizations

          attributes do
            property :name, as: :label
            property :name
          end
        end

        has_one :section, class: ::Section,
                          populator: API::V1::Lib::Populators::Find do
          type :sections

          attributes do
            property :identifier, as: :label
            property :identifier
          end
        end

        has_one :city, class: ::City,
                       populator: API::V1::Lib::Populators::Find do
          type :cities

          attributes do
            property :name, as: :label
            property :name
          end
        end

        has_one :area, class: ::Area,
                       populator: API::V1::Lib::Populators::Find do
          type :areas

          attributes do
            property :name, as: :label
            property :name
          end
        end

        has_many :presumed_categories, class: ::Category do
          type :categories

          attributes do
            property :name_de, as: :label
            property :name_de
          end
        end

        has_many :presumed_solution_categories, class: ::SolutionCategory do
          type :solution_categories

          attributes do
            property :name, as: :label
            property :name
          end
        end

        has_many :websites,
                 class: ::Website,
                 decorator: API::V1::Website::Representer::Show,
                 populator: API::V1::Lib::Populators::FindOrInstantiate
      end
    end
  end
end
