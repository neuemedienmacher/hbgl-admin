# frozen_string_literal: true
module API::V1
  module ContactPersonTranslation
    class Index < API::V1::Default::Index
      def base_query
        ::ContactPersonTranslation
      end
    end
  end
end
