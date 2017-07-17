# frozen_string_literal: true
module API::V1
  module TimeAllocation
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :time_allocations

        attributes do
          property :user_id # TODO: json api spec: relationship
          property :year
          property :week_number
          property :desired_wa_hours
          property :actual_wa_hours
          property :actual_wa_comment
        end
      end
    end
  end
end
