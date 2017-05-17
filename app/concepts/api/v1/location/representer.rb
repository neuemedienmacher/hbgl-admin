# frozen_string_literal: true
module API::V1
  module Location
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :locations

        attributes do
          property :display_name, as: :label
        end
      end
    end
  end
end
