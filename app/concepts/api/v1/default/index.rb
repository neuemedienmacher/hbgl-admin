# frozen_string_literal: true

module API::V1
  module Default
    class Index < Trailblazer::Operation
      step :find_result_set, name: 'find_result_set'

      def find_result_set(options, params:, **)
        query = GenericSortFilter.transform(base_query, params)
        options['collection'] =
          query.paginate(page: params[:page], per_page: params[:per_page])
      end

      def base_query
        raise 'Implement Index Operation #base_query'
      end
    end
  end
end
