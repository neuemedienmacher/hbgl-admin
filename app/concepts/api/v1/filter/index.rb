# frozen_string_literal: true
module API::V1
  module Filter
    class Index < API::V1::Default::Index
      def base_query
        ::Filter
      end

      representer API::V1::Filter::Representer::Index
    end

    module SectionFilter
      class Index < API::V1::Filter::Index
        def base_query
          ::SectionFilter
        end
      end
    end
  end
end
