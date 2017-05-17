# frozen_string_literal: true
module API::V1
  module Website
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :websites

        attributes do
          property :label, getter: ->(website) do
            website[:represented].url
          end
          property :host
          property :url
        end
      end
    end
  end
end
