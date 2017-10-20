# frozen_string_literal: true

module API::V1
  module Version
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :versions

        attributes do
          property :label, getter: ->(object) { "##{object[:represented].id}" }

          property :item_type
          property :item_id
          property :event
          property :whodunnit
          property :object
          property :object_changes
          property :created_at
        end
      end

      class Index < Show
      end
    end
  end
end
