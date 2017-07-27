# frozen_string_literal: true
module API::V1
  module Division
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :divisions
        include API::V1::Assignable::Representer

        attributes do
          property :label, getter: ->(division) do
            division[:represented].display_name
          end

          property :addition
          property :comment
          property :size
          property :done

          property :organization_id
          property :section_id
          property :city_id
          property :area_id

          # NOTE: do we need this here? or only for create/update or not at all?
          property :website_ids
          property :presumed_category_ids
          property :presumed_solution_category_ids
        end

        has_one :organization, class: ::Organization do
          type :organizations

          attributes do
            property :label, getter: ->(o) { o[:represented].name }
            property :name
          end
        end

        has_one :section, class: ::Section,
                          populator: API::V1::Lib::Populators::Find do
          type :sections

          attributes do
            property :label, getter: ->(o) { o[:represented].identifier }
            property :identifier
          end
        end

        has_one :city, class: ::City,
                       populator: API::V1::Lib::Populators::Find do
          type :cities

          attributes do
            property :label, getter: ->(o) { o[:represented].name }
            property :name
          end
        end

        has_one :area, class: ::Area,
                       populator: API::V1::Lib::Populators::Find do
          type :areas

          attributes do
            property :label, getter: ->(o) { o[:represented].name }
            property :name
          end
        end
      end

      class Index < Show
      end

      class Create < Index
        has_many :presumed_categories, class: ::Category do
          type :categories

          attributes do
            property :label, getter: ->(o) { o[:represented].name_de }
            property :name_de
          end
        end

        has_many :presumed_solution_categories, class: ::SolutionCategory do
          type :solution_categories

          attributes do
            property :label, getter: ->(o) { o[:represented].name }
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
