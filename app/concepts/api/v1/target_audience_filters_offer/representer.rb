# frozen_string_literal: true
module API::V1
  module TargetAudienceFiltersOffer
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :target_audience_filters_offers

        attributes do
          property :label, getter: ->(split_base) {
            split_base[:represented].name
          }
          property :residency_status
          property :gender_first_part_of_stamp
          property :gender_second_part_of_stamp
          property :age_from
          property :age_to
          property :age_visible
          property :stamp_de

          property :target_audience_filter_id
          property :offer_id
        end
      end

      class Index < Show
      end

      class Create < Show
        has_one :target_audience_filter,
                decorator: API::V1::Filter::Representer::Show,
                populator: API::V1::Lib::Populators::Find,
                class: ::TargetAudienceFilter

        has_one :offer,
                decorator: API::V1::Offer::Representer::Show,
                populator: API::V1::Lib::Populators::Find,
                class: ::Offer
      end
    end
  end
end
