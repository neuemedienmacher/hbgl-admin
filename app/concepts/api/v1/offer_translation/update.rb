# frozen_string_literal: true

module API::V1
  module OfferTranslation
    class Update < ::OfferTranslation::Update
      extend Trailblazer::Operation::Representer::DSL
      representer Representer::Show
    end
  end
end
