# frozen_string_literal: true

module API::V1
  module FederalState
    class Index < API::V1::Default::Index
      def base_query
        ::FederalState
      end
    end
  end
end
