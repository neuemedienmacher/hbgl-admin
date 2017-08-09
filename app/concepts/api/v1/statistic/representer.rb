# frozen_string_literal: true
module API::V1
  module Statistic
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :statistics

        attributes do
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
        end

        has_one :trackable do
          type :trackable_type
          # Above is technically incorrect. Wish the following would work ...
          # as[:represented].trackable_type.tableize.to_sym

          attributes do
            property :label, getter: ->(object) do
              "#{object[:represented].class.name}##{object[:represented].id}"
            end
          end
        end
      end

      class Index < Show
      end
    end
  end
end
