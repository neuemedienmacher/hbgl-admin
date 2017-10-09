# frozen_string_literal: true

module API::V1
  module Offer
    class Index < API::V1::Default::Index
      def base_query
        ::Offer
      end
    end
  end
end
