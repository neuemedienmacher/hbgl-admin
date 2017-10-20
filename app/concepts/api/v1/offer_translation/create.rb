# frozen_string_literal: true

module API::V1
  module OfferTranslation
    class Create < ::OfferTranslation::Create
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::OfferTranslation::Representer::Show
    end
  end
end
