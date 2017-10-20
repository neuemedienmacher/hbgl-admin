# frozen_string_literal: true

module API::V1
  module Offer
    class Create < ::Offer::Create
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::Offer::Representer::Create
    end

    class Update < ::Offer::Update
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::Offer::Representer::Update
    end
  end
end
