# frozen_string_literal: true

module API::V1
  module ContactPersonTranslation
    class Create < ::ContactPersonTranslation::Create
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::ContactPersonTranslation::Representer::Show
    end
  end
end
