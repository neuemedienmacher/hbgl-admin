# frozen_string_literal: true
module API::V1
  module TargetAudienceFiltersOffer
    class Index < API::V1::Default::Index
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::TargetAudienceFiltersOffer::Representer::Index

      def base_query
        ::TargetAudienceFiltersOffer
      end
    end
  end
end
