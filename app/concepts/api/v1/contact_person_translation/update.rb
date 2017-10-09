# frozen_string_literal: true

module API::V1
  module ContactPersonTranslation
    class Update < ::ContactPersonTranslation::Update
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::ContactPersonTranslation::Representer::Show
    end
  end
end
