# frozen_string_literal: true
module API::V1
  module Division
    class Create < Trailblazer::Operation
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::Division::Representer::Show
    end
  end
end
