# frozen_string_literal: true

class NextStepsOffersController < ApplicationController
  respond_to :json

  def index
    nsos = NextStepsOffer.where(offer_id: params[:offer_id]).joins(:next_step)
    array = nsos.all.map { |nso| { id: nso.id, name: nso.next_step.text_de } }
    respond_with array
  end

  def update
    nso = NextStepsOffer.find(params[:id])
    nso.update_attributes params.require(:next_steps_offer).permit(:sort_value)
    render status: 200, json: { result: 'success' }
  end
end
