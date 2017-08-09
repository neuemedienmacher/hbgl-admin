# frozen_string_literal: true
module API::V1
  module Division
    class Create < ::Division::Create
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::Division::Representer::Create
    end
  end
end
