# frozen_string_literal: true

module API::V1
  module Location
    class Index < API::V1::Default::Index
      def base_query
        ::Location
      end
    end
  end
end
