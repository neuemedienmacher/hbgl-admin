# frozen_string_literal: true

module API::V1
  module City
    module Representer
      # NOTE for heroku deploy :|
      require_relative '../lib/populators.rb'
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :cities

        attributes do
          property :name
          property :label, getter: ->(city) {
            city[:represented].name
          }
          property :created_at
          property :updated_at
        end
      end

      class Index < Show
      end

      class Create < Show
      end
    end
  end
end
