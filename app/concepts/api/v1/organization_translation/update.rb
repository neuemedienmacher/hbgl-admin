# frozen_string_literal: true

module API::V1
  module OrganizationTranslation
    class Update < ::OrganizationTranslation::Update
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::OrganizationTranslation::Representer::Show
    end
  end
end
