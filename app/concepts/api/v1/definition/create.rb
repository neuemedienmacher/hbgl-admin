# frozen_string_literal: true

module API::V1
  module Definition
    class Create < ::Definition::Create
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::Definition::Representer::Create
    end
  end
end
