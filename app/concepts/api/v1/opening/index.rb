# frozen_string_literal: true

module API::V1
  module Opening
    class Index < API::V1::Default::Index
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::Opening::Representer::Index

      def base_query
        ::Opening
      end
    end
  end
end
