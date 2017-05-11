# frozen_string_literal: true
module API::V1
  module Division
    module Representer
      class Show < API::V1::Default::Representer::Show
        # type :divisions
        include Roar::JSON::JSONAPI.resource :divisions

        attributes do
          property :label, getter: ->(division) do
            division[:represented].name
          end

          property :name
          property :comment
          property :size

          property :website_id

          property :organization_id
          property :section_id
        end

        has_one :organization do
          type :organizations

          attributes do
            property :name, as: :label
          end
        end

        has_one :section do
          type :sections

          attributes do
            property :identifier, as: :label
          end
        end

        has_many :presumed_categories do
          type :categories

          attributes do
            property :name_de, as: :label
          end
        end

        has_many :presumed_solution_categories do
          type :solution_categories

          attributes do
            property :name_de, as: :label
          end
        end
      end

      class Index < Show
      end
    end
  end
end
