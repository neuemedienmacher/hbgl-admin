# frozen_string_literal: true

module API::V1
  module SearchLocation
    class Index < API::V1::Default::Index
      def base_query
        ::SearchLocation
      end
    end
  end
end
