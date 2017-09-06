# frozen_string_literal: true
module API::V1
  module Definition
    class Update < ::Definition::Update
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::Definition::Representer::Update
    end
  end
end
