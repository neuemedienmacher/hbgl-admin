# frozen_string_literal: true
module API::V1
  module Organization
    class Create < ::Organization::Create
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::Organization::Representer::Create
    end

    class Update < ::Organization::Update
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::Organization::Representer::Update
    end
  end
end
