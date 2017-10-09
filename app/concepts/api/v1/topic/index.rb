# frozen_string_literal: true

module API::V1
  module Topic
    class Index < API::V1::Default::Index
      def base_query
        ::Topic
      end
    end
  end
end
