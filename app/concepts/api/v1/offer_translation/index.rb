# frozen_string_literal: true
module API::V1
  module OfferTranslation
    class Index < API::V1::Default::Index
      def base_query
        ::OfferTranslation
          .where(locale: [:en, :ar, :fa])
          .joins(:section_filter).where('section_filters.identifier = ?', 'family')
      end
    end
  end
end

::OfferTranslation.where(locale: [:en, :ar, :fa]).joins(:offer).where('offers.section_filter_id = ?', '2')