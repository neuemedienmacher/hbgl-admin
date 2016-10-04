# frozen_string_literal: true
module API::V1
  module Default
    class Index < Trailblazer::Operation
      include Trailblazer::Operation::Representer

      def process(*)
      end

      def to_json(options={})
        hash = self.class.representer_class.for_collection.new(represented)
          .to_hash options
        hash[:meta] = meta if meta
        hash[:links] = links if links
        hash.to_json
      end

      def model!(params)
        query = GenericSortFilter.transform(base_query, params)
        query.paginate(page: params[:page])
      end

      def base_query
        raise 'Implement Operation #base_query'
      end

      protected

      def meta
        {
          total_entries: model.total_entries,
          total_pages: model.total_pages,
          current_page: model.current_page,
          per_page: model.per_page
        }
      end

      def links
        {
          previous: previous_href,
          next: next_href,
        }
      end

      private

      def nonstandard_params
        @params.select do |key, _value|
          !%w(controller action format).include? key
        end
      end

      def previous_href
        return nil unless model.previous_page
        '/' + @params['controller'] + '?' +
          nonstandard_params.merge(page: model.previous_page).to_query
      end

      def next_href
        return nil unless model.next_page
        '/' + @params['controller'] + '?' +
          nonstandard_params.merge(page: model.next_page).to_query
      end
    end
  end
end
