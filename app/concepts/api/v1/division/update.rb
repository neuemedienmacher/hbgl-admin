# frozen_string_literal: true

module API::V1
  module Division
    class Update < ::Division::Update
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::Division::Representer::Create
    end
  end
end
