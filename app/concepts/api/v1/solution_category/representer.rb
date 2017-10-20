# frozen_string_literal: true

module API::V1
  module SolutionCategory
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :solution_categories

        attributes do
          property :name
          property :parent_id

          property :label, getter: ->(solution_category) do
            solution_category[:represented].name
          end
        end

        has_one :parent, class: ::SolutionCategory do
          type :solution_categories

          attributes do
            property :label, getter: ->(s) { s[:represented].name }
            property :name
          end
        end
      end

      class Index < Show
      end

      class Create < Show
      end
    end
  end
end
