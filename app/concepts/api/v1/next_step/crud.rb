# frozen_string_literal: true

module API::V1
  module NextStep
    class Create < ::NextStep::Create
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::NextStep::Representer::Create
    end

    class Update < ::NextStep::Update
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::NextStep::Representer::Create
    end
  end
end
