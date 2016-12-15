# frozen_string_literal: true
module API::V1
  module City
    class Index < API::V1::Default::Index
      def base_query
        ::City
      end

      representer API::V1::City::Representer::Index
    end
  end
end
