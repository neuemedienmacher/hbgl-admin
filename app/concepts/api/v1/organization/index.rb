# frozen_string_literal: true
module API::V1
  module Organization
    class Index < API::V1::Default::Index
      def base_query
        ::Organization
      end
    end
  end
end
