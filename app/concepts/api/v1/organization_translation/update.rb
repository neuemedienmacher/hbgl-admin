# frozen_string_literal: true
module API::V1
  module OrganizationTranslation
    class Update < ::OrganizationTranslation::Update
      include Trailblazer::Operation::Representer, Responder

      representer Representer::Show

      def validatable_params
        @params[:json]
      end
    end
  end
end
