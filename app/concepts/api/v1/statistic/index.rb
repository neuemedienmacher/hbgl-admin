# frozen_string_literal: true

module API::V1
  module Statistic
    class Index < API::V1::Default::Index
      def base_query
        ::Statistic
        # if params['user_id'] != 'all'
        #   query.where(user_id: params['user_id'])
        # end
      end
    end
  end
end
