require 'roar/decorator'
require 'roar/json'

module API::V1
  module Default
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON

        property :id
      end

      class Index < Roar::Decorator
        include Representable::JSON::Collection
      end
    end
  end
end
