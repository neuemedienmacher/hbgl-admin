# frozen_string_literal: true
module API::V1
  module Division
    class Index < API::V1::Default::Index
      def base_query
        ::Division
      end

      representer API::V1::Division::Representer::Index
    end
  end
end
