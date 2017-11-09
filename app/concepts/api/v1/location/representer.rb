# frozen_string_literal: true

module API::V1
  module Location
    module Representer
      # NOTE for heroku deploy :|
      require_relative '../lib/populators.rb'
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :locations

        attributes do
          property :label
          property :name
          property :street
          property :addition
          property :zip
          property :hq
          property :visible
          property :in_germany

          property :latitude
          property :longitude
          property :created_at
          property :updated_at

          property :organization_id
          property :city_id
          property :federal_state_id

          property :offer_ids
        end

        has_one :organization do
          type :organizations
          attributes do
            property :label, getter: ->(o) { o[:represented].name }
            property :name
          end
        end

        has_one :federal_state do
          type :federal_states
          attributes do
            property :label, getter: ->(o) { o[:represented].name }
            property :name
          end
        end

        has_one :city do
          type :cities
          attributes do
            property :label, getter: ->(o) { o[:represented].name }
            property :name
          end
        end
      end

      class Index < Show
      end

      class Create < Show
        has_one :organization,
                decorator: API::V1::Organization::Representer::Show,
                populator: API::V1::Lib::Populators::Find, class: ::Organization

        has_one :federal_state,
                decorator: API::V1::FederalState::Representer::Show,
                populator: API::V1::Lib::Populators::Find, class: ::FederalState

        has_one :city,
                decorator: API::V1::City::Representer::Show,
                populator: API::V1::Lib::Populators::Find, class: ::City
      end

      # class Update < Roar::Decorator
      #   include Roar::JSON::JSONAPI.resource :locations
      #
      #   attributes do
      #     property :label
      #     property :name
      #     property :street
      #     property :addition
      #     property :zip
      #     property :hq
      #     property :visible
      #     property :in_germany
      #
      #     property :organization_id
      #     property :city_id
      #     property :federal_state_id
      #   end
      # end
    end
  end
end
