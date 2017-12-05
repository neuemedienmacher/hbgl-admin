# frozen_string_literal: true

module API::V1
  module LanguageFilter
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :language_filters

        attributes do
          property :label, getter: ->(filter) do
            filter[:represented].name
          end

          property :identifier
          property :name
        end
      end

      class Index < Show
      end
    end
  end
end
