# frozen_string_literal: true
module API::V1
  module TimeAllocation
    module Representer
      class Show < API::V1::Default::Representer::Show
        type :time_allocations
        property :user_id # TODO: json api spec: relationship
        property :year
        property :week_number
        property :desired_wa_hours
        property :actual_wa_hours
      end
    end
  end
end
