# frozen_string_literal: true
module API::V1
  module Filter
    class Index < API::V1::Default::Index
      def base_query
        ::Filter
      end
    end
  end
end
