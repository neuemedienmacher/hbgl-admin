# frozen_string_literal: true

module API::V1
  module Lib
    module JsonifyCollection
      def self.call(representer_class, collection, params)
        representer = representer_class.for_collection.prepare(collection)
        hash = representer.to_hash
        hash[:meta] = meta(collection) if meta(collection)
        hash[:links] = links(collection, params) if links(collection, params)
        hash.to_json
      end

      private_class_method

      def self.meta(collection)
        {
          total_entries: collection.total_entries,
          total_pages: collection.total_pages,
          current_page: collection.current_page,
          per_page: collection.per_page
        }
      end

      def self.links(collection, params)
        {
          previous: previous_href(collection, params),
          next: next_href(collection, params)
        }
      end

      def self.nonstandard_params(params)
        new_params = params.reject do |key, _value|
          %w[controller action format].include? key
        end
        sanitize_params(new_params)
      end

      def self.sanitize_params(params)
        params.class.eql?(Hash) ? params : params.to_unsafe_h
      end

      def self.previous_href(collection, params)
        return nil unless collection.previous_page
        '/' + params['controller'] + '?' +
          nonstandard_params(params).merge(page: collection.previous_page).to_query
      end

      def self.next_href(collection, params)
        return nil unless collection.next_page
        '/' + params['controller'] + '?' +
          nonstandard_params(params).merge(page: collection.next_page).to_query
      end
    end
  end
end
