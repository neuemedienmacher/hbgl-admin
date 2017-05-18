# frozen_string_literal: true
module API::V1
  module Category
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :categories

        attributes do
          property :name
          property :visible

          property :label, getter: ->(category) do
            category[:represented].name_de
          end
        end

        has_many :children,
                 class: Category, decorator: Show,
                 if: ->(opts) { opts[:represented].children.any? }
      end
    end
  end
end
