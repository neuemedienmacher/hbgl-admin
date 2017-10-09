# frozen_string_literal: true

module API::V1
  module Assignment
    class Create < ::Assignment::Create
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::Assignment::Representer::Show
    end
  end
end
