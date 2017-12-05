# frozen_string_literal: true

module API::V1
  module Contact
    class Index < API::V1::Default::Index
      def base_query
        ::Contact
      end
    end
  end
end
