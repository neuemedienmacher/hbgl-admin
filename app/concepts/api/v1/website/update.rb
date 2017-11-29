# frozen_string_literal: true

module API::V1
  module Website
    class Update < ::Website::Update
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::Website::Representer::Show
    end
  end
end
