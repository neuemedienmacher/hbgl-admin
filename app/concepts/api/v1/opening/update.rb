# frozen_string_literal: true

module API::V1
  module Opening
    class Update < ::Opening::Update
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::Opening::Representer::Update
    end
  end
end
