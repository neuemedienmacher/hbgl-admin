# frozen_string_literal: true
module API::V1
  module Statistic
    module Representer
      class Show < API::V1::Default::Representer::Show
        property :topic
        property :user_id
        property :date
        property :count
        property :model
        property :field_name
        property :field_start_value
        property :field_end_value
      end

      class Index < API::V1::Default::Representer::Index
        # items extend: Show
      end
    end
  end
end
