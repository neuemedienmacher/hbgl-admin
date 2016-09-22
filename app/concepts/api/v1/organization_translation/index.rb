# frozen_string_literal: true
module API::V1
  module OrganizationTranslation
    class Index < API::V1::Default::Index
      def base_query
        ::OrganizationTranslation.where(locale: [:ar, :en])
      end

      representer API::V1::OrganizationTranslation::Representer::Index
    end
  end
end
