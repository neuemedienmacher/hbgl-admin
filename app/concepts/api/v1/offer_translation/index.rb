# frozen_string_literal: true

module API::V1
  module OfferTranslation
    class Index < API::V1::Default::Index
      def base_query
        ::OfferTranslation
        # NOTE: this must be manually filtered from now on!
        # .where(locale: ['en', 'ar', 'fa'])
        # .joins(:section).where('sections.identifier = ?', 'refugees')
      end
    end
  end
end
