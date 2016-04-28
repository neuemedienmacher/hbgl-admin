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
    validate(params[:export]) do |form_object|
      binding.pry
      true
    end
  end
end
