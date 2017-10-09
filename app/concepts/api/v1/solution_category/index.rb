# frozen_string_literal: true

module API::V1
  module SolutionCategory
    class Index < API::V1::Default::Index
      def base_query
        ::SolutionCategory
      end
    end
  end
end
