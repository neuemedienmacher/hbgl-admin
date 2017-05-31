# frozen_string_literal: true
module API::V1
  module Email
    class Create < ::Email::Create
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::Email::Representer::Show
    end
  end
end
