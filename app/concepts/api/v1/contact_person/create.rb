# frozen_string_literal: true

module API::V1
  module ContactPerson
    class Create < ::ContactPerson::Create
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::ContactPerson::Representer::Create
    end
  end
end
