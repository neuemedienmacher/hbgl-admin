# frozen_string_literal: true

module API::V1
  module Website
    class Index < API::V1::Default::Index
      step :remove_prefix, before: 'find_result_set'

      def remove_prefix(options, _, **)
        if options['params']['query']
          options['params']['query'] =
            options['params']['query'].gsub(%r{\Ahttps?:\/\/}, '')
        end
        true
      end

      def base_query
        ::Website
      end
    end
  end
end
