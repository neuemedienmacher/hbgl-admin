# frozen_string_literal: true
module API::V1
  module OrganizationTranslation
    class Update < Trailblazer::Operation
      include Trailblazer::Operation::Representer, Responder
      representer Representer::Show

      include Model
      model ::OrganizationTranslation, :update

      contract do
        property :description
        property :source
        property :possibly_outdated
      end

      def process(params)
        validate(params[:json]) do |form_object|
          form_object.source = 'researcher'
          form_object.possibly_outdated = false
          form_object.save
        end
      end
    end
  end
end
