# frozen_string_literal: true

module API::V1
  module Subscription
    class Index < API::V1::Default::Index
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::Subscription::Representer::Index

      def base_query
        ::Subscription
      end
    end
  end
end
