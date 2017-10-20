# frozen_string_literal: true

module API::V1
  module UpdateRequest
    class Index < API::V1::Default::Index
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::UpdateRequest::Representer::Index

      def base_query
        ::UpdateRequest
      end
    end
  end
end
