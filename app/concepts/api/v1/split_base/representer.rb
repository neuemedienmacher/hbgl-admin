# frozen_string_literal: true

module API::V1
  module SplitBase
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :split_bases

        attributes do
          property :title
          property :id
          property :label
          property :solution_category_id
          property :clarat_addition
          property :comments
          property :created_at
          property :updated_at
          property :division_ids
        end
      end

      class Index < Show
        has_one :solution_category, class: ::SolutionCategory do
          type :solution_categories

          attributes do
            property :label, getter: ->(o) { o[:represented].name }
            property :name
          end
        end

        has_many :divisions, class: ::Division do
          type :divisions

          attributes do
            property :label
          end
        end
      end

      class Create < Index
        has_one :solution_category,
                decorator: API::V1::SolutionCategory::Representer::Show,
                populator: API::V1::Lib::Populators::FindOrInstantiate,
                class: ::SolutionCategory
      end
    end
  end
end
