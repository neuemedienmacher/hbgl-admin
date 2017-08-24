# frozen_string_literal: true
module API::V1
  module NextStep
    class Index < API::V1::Default::Index
      def base_query
        ::NextStep
      end
    end
  end
end
