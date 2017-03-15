# frozen_string_literal: true
require 'roar/decorator'
require 'roar/json/json_api'

module API::V1
  module Default
    module Representer
      class Show < Roar::Decorator
        # include Roar::JSON
        include Roar::JSON::JSONAPI

        property :id
      end

      class Index < Roar::Decorator
        # include Roar::JSON::JSONAPI
      end
    end
  end
end
