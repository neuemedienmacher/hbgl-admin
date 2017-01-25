# frozen_string_literal: true
module API::V1
  module Category
    class Index < API::V1::Default::Index
      def model!(_params)
        ::Category.mains
      end
    end
  end
end
