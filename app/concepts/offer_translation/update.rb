# frozen_string_literal: true
class OfferTranslation::Update < Trailblazer::Operation
  include Model
  model OfferTranslation, :update

  contract do
    property :name
    property :description
    property :opening_specification
    property :source
    property :possibly_outdated
  end

  def process(params)
    validate(validatable_params) do |form_object|
      form_object.source = 'researcher'
      form_object.possibly_outdated = false
      form_object.save
    end
  end

  def validatable_params
    @params[:offer_translation]
  end
end
