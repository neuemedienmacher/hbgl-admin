# frozen_string_literal: true

module API::V1
  module SplitBase
    class Index < API::V1::Default::Index
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::SplitBase::Representer::Index

      def base_query
        ::SplitBase
      end
    end
  end
end
