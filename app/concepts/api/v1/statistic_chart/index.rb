# frozen_string_literal: true
module API::V1
  module StatisticChart
    class Index < API::V1::Default::Index
      def base_query
        ::StatisticChart
      end
    end
  end
end
