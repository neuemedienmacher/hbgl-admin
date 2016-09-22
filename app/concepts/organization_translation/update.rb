# frozen_string_literal: true
class OrganizationTranslation::Update < Trailblazer::Operation
  include Model
  model OrganizationTranslation, :update

  contract do
    property :description
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
    @params[:organization_translation]
  end
end
