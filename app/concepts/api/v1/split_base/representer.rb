# frozen_string_literal: true
module API::V1
  module SplitBase
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :split_bases

        attributes do
          property :title
          property :label, getter: ->(split_base) {
            split_base[:represented].title
          }
          property :clarat_addition
          property :comments
          property :created_at
          property :updated_at
        end
      end

      class Index < Show
      end
    end
  end
end
