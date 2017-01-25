# frozen_string_literal: true
module API::V1
  module ProductivityGoal
    class Create < ::ProductivityGoal::Create
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::ProductivityGoal::Representer::Show
    end

    class Update < ::ProductivityGoal::Update
    end
  end
end
