# frozen_string_literal: true
module API::V1
  module TargetAudienceFiltersOffer
    class Create < ::TargetAudienceFiltersOffer::Create
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::TargetAudienceFiltersOffer::Representer::Create
    end
  end
end
