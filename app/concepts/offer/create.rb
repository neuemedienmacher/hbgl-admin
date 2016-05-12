# frozen_string_literal: true
class Offer::Create < Trailblazer::Operation
  include Model
  model Offer, :create

  contract do
    property :name
    property :organizations
    property :encounter
    property :location
  end

  def process(params)
    validate(params[:export]) do |_form_object|
      true
    end
  end
end
