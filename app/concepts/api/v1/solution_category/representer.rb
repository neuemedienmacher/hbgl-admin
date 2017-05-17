# frozen_string_literal: true
module API::V1
  module SolutionCategory
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :solution_categories

        attributes do
          property :name

          property :label, getter: ->(solution_category) do
            solution_category[:represented].name
          end
        end
      end
    end
  end
end
