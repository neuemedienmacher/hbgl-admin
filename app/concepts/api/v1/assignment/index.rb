# frozen_string_literal: true
module API::V1
  module Assignment
    class Index < API::V1::Default::Index
      def base_query
        ::Assignment
      end

      representer API::V1::Assignment::Representer::Show
    end
  end
end
