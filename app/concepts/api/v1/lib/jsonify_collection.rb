module API::V1
  module Lib
    module JsonifyCollection
      def self.call(base_module, collection, params)
        representer = "#{base_module}::Representer::Show".constantize
          .for_collection.new(collection)
        hash = representer.to_hash
        hash[:meta] = meta(collection) if meta(collection)
        hash[:links] = links(collection, params) if links(collection, params)
        hash.to_json
      end

      private

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
          next: next_href(collection, params),
        }
      end

      private

      def self.nonstandard_params(params)
        params.select do |key, _value|
          !%w(controller action format).include? key
        end
      end

      def self.previous_href(collection, params)
        return nil unless collection.previous_page
        '/' + params['controller'] + '?' +
          nonstandard_params(params).merge(page: collection.previous_page)
            .to_query
      end

      def self.next_href(collection, params)
        return nil unless collection.next_page
        '/' + params['controller'] + '?' +
          nonstandard_params(params).merge(page: collection.next_page).to_query
      end
    end
  end
end
