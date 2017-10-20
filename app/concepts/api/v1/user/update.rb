# frozen_string_literal: true

module API::V1
  module User
    class Update < ::User::Update
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::User::Representer::Update
    end
  end
end
