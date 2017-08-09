# frozen_string_literal: true
module API::V1
  module City
    class Index < API::V1::Default::Index
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::City::Representer::Index

      def base_query
        ::City
      end
    end
  end
end
