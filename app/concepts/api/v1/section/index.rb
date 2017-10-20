# frozen_string_literal: true

module API::V1
  module Section
    class Index < API::V1::Default::Index
      def base_query
        ::Section
      end
    end
  end
end
