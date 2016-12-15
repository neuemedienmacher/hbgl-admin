# frozen_string_literal: true
module API::V1
  module OfferTranslation
    class Update < Trailblazer::Operation
      include Trailblazer::Operation::Representer, Responder
      representer Representer::Show

      include Model
      model ::OfferTranslation, :update

      contract do
        property :name
        property :description
        property :opening_specification
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
