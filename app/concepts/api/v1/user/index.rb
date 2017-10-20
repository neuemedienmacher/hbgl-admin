# frozen_string_literal: true

module API::V1
  module User
    class Index < API::V1::Default::Index
      def base_query
        ::User
      end
    end
  end
end
