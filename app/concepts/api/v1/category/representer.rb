# frozen_string_literal: true
module API::V1
  module Category
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :categories

        attributes do
          property :name_de
          property :visible
          property :section_ids
          property :child_ids

          property :label, getter: ->(category) do
            category[:represented].name_de +
              " (#{::Section.where(id: section_ids).pluck(:identifier).join(',')})"
          end
        end
      end

      class Index < Show
      end

      class Create < Show
        has_many :sections, class: ::Section,
                            populator: API::V1::Lib::Populators::Find do
          type :sections

          attributes do
            property :label, getter: ->(o) { o[:represented].identifier }
            property :identifier
          end
        end

        has_many :children,
                 class: Category, decorator: Show,
                 if: ->(opts) { opts[:represented].children.any? }
      end
    end
  end
end
