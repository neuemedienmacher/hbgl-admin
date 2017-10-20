# frozen_string_literal: true

module API::V1
  module LogicVersion
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :logic_versions

        attributes do
          property :label, getter: ->(filter) do
            "#{filter[:represented].version} - #{filter[:represented].name}"
          end

          property :version
          property :name
          property :description
        end
      end

      class Index < Show
      end
    end
  end
end
