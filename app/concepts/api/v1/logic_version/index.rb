# frozen_string_literal: true
module API::V1
  module LogicVersion
    class Index < API::V1::Default::Index
      def base_query
        ::LogicVersion
      end
    end
  end
end
