require 'roar/decorator'
require 'roar/json'

module API::V1
  module Category
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON

        property :name
        property :visible
        collection :children, extend: Show
      end

      class Index < Roar::Decorator
        include Representable::JSON::Collection
        items extend: Show
      end
    end
  end
end
