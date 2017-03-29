# frozen_string_literal: true
module API::V1
  module Filter
    module Index
      class General < API::V1::Default::Index
        def base_query
          ::Filter
        end
      end

      class SectionFilter < API::V1::Filter::Index::General
        def base_query
          ::SectionFilter
        end
      end
    end
  end
end
