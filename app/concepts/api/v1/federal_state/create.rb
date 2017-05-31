# frozen_string_literal: true
module API::V1
  module FederalState
    class Create < ::FederalState::Create
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::FederalState::Representer::Show
    end
  end
end
