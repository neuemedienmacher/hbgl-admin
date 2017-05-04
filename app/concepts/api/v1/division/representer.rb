# frozen_string_literal: true
module API::V1
  module Division
    module Representer
      class Show < API::V1::Default::Representer::Show
        type :divisions

        property :label, getter: ->(division) do
          division[:represented].name
        end

        property :name

        property :organization_id
        has_one :organization do
          type :organizations

          property :id
          property :name, as: :label
        end

        property :section_id
        has_one :section do
          type :sections

          property :id
          property :identifier, as: :label
        end

        has_many :presumed_categories do
          type :categories

          property :id
          property :name_de, as: :label
        end

        has_many :presumed_solution_categories do
          type :solution_categories

          property :id
          property :name_de, as: :label
        end
      end

      class Index < Show
      end
    end
  end
end
