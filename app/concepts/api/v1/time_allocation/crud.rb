# frozen_string_literal: true

module API::V1
  module TimeAllocation
    class Create < ::TimeAllocation::Create
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::TimeAllocation::Representer::Show
    end

    class Update < ::TimeAllocation::Update
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::TimeAllocation::Representer::Show
    end
  end
end
