class Offer::Create < Trailblazer::Operation
  include Model
  model Offer, :create

  def process(params)
    # do whatever you feel like.
  end
end
