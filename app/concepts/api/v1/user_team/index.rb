# frozen_string_literal: true
module API::V1
  module UserTeam
    class Index < API::V1::Default::Index
      def base_query
        ::UserTeam
      end

      representer API::V1::UserTeam::Representer::Show
    end
  end
end
