# frozen_string_literal: true
module API::V1
  module Location
    class Create < ::Location::Create
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::Location::Representer::Show
    end
  end
end
