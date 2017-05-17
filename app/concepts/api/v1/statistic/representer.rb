# frozen_string_literal: true
module API::V1
  module Statistic
    module Representer
      class Show < API::V1::Default::Representer::Show
        type :statistics

        property :topic
        property :time_frame
        property :trackable_id
        property :trackable_type
        property :date
        property :count
        property :model
        property :field_name
        property :field_start_value
        property :field_end_value

        has_one :trackable do
          type :trackable_type
          # Above is technically incorrect. Wish the following would work ...
          # as[:represented].trackable_type.tableize.to_sym

          property :id
          property :label, getter: ->(object) do
            "#{object[:represented].class.name}##{object[:represented].id}"
          end
        end
      end

      class Index < API::V1::Default::Representer::Index
        # items extend: Show
      end
    end
  end
end
