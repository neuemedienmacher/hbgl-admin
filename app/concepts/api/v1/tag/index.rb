# frozen_string_literal: true
module API::V1
  module Tag
    class Index < API::V1::Default::Index
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::Tag::Representer::Index

      def base_query
        ::Tag
      end
    end
  end
end
