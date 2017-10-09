# frozen_string_literal: true

module API::V1
  module Email
    class Index < API::V1::Default::Index
      def base_query
        ::Email
      end
    end
  end
end
