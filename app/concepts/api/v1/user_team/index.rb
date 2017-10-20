# frozen_string_literal: true

module API::V1
  module UserTeam
    class Index < API::V1::Default::Index
      def base_query
        ::UserTeam
      end
    end
  end
end
