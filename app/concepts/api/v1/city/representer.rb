# frozen_string_literal: true
module API::V1
  module City
    module Representer
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
        has_many :divisions, class: ::Division do
          type :divisions

          attributes do
            property :label, getter: ->(item) do
              item[:represented].name
            end
            property :name
          end
        end

        has_many :locations, class: ::Location do
          type :locations

          attributes do
            property :label, getter: ->(item) do
              item[:represented].name
            end
            property :name
          end
        end

        has_many :offers, class: ::Offer do
          type :offers

          attributes do
            property :label, getter: ->(item) do
              item[:represented].untranslated_name
            end
            property :untranslated_name
          end
        end

        has_many :organizations, class: ::Organization do
          type :organizations

          attributes do
            property :label, getter: ->(item) do
              item[:represented].name
            end
            property :name
          end
        end

        has_many :sections, class: ::Section do
          type :sections

          attributes do
            property :label, getter: ->(item) do
              item[:represented].name
            end
            property :name
          end
        end
      end
    end
  end
end
