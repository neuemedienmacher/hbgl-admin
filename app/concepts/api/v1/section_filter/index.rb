# frozen_string_literal: true
module API::V1
  module SectionFilter
    class Index < API::V1::Default::Index
      def base_query
        ::SectionFilter
      end
    end
  end
end
