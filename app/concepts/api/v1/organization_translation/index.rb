# frozen_string_literal: true

module API::V1
  module OrganizationTranslation
    class Index < API::V1::Default::Index
      def base_query
        ::OrganizationTranslation
        # .where(locale: [:en, :ar, :fa]).uniq
        # .joins(:sections).where('sections.identifier = ?', 'refugees')
      end
    end
  end
end
