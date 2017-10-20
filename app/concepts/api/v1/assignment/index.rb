# frozen_string_literal: true

module API::V1
  module Assignment
    class Index < API::V1::Default::Index
      def base_query
        ::Assignment
      end
    end
  end
end
