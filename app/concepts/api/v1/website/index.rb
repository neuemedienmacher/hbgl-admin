# frozen_string_literal: true
module API::V1
  module Website
    class Index < API::V1::Default::Index
      def base_query
        ::Website
      end

      representer API::V1::Website::Representer::Show
    end
  end
end
