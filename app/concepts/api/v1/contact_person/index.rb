# frozen_string_literal: true

module API::V1
  module ContactPerson
    class Index < API::V1::Default::Index
      def base_query
        ::ContactPerson
      end
    end
  end
end
