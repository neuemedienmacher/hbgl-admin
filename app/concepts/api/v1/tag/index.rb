# frozen_string_literal: true
module API::V1
  module Tag
    class Index < API::V1::Default::Index
      def base_query
        ::Tag
      end
    end
  end
end
