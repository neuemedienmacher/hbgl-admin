# frozen_string_literal: true

module API::V1
  module City
    class Create < ::City::Create
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::City::Representer::Create
    end
  end
end
