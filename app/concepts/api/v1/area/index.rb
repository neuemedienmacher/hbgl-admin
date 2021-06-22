# frozen_string_literal: true

module API::V1
  module Area
    class Index < API::V1::Default::Index
      extend Trailblazer::Operation::Representer::DSL

      def base_query
        ::Area
      end
    end
  end
end
