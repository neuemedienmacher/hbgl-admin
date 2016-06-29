# frozen_string_literal: true
module API::V1
  module User
    class Index < API::V1::Default::Index
      def model!(params)
        query = ::User
        return query.all
      end

      representer API::V1::User::Representer::Index
    end
  end
end
