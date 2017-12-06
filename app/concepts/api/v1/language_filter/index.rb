# frozen_string_literal: true

module API::V1
  module LanguageFilter
    class Index < API::V1::Default::Index
      def base_query
        ::Filter
          .where(type: 'LanguageFilter')
      end
    end
  end
end
