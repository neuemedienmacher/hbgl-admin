# frozen_string_literal: true
module API::V1
  module Opening
    class Create < ::Opening::Create
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::Opening::Representer::Create
    end
  end
end
