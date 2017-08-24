# frozen_string_literal: true
module API::V1
  module Definition
    class Index < API::V1::Default::Index
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::Definition::Representer::Index

      def base_query
        ::Definition
      end
    end
  end
end
