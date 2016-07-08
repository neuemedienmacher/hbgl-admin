# frozen_string_literal: true
module API::V1
  module Statistic
    class Index < API::V1::Default::Index
      def model!(params)
        query = ::Statistic
        # if params['user_id'] != 'all'
        #   return query.where(user_id: params['user_id'])
        # else
        query.all
        # end
      end

      representer API::V1::Statistic::Representer::Index
    end
  end
end
