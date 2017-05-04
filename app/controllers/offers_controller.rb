# frozen_string_literal: true
class OffersController < ApplicationController
  include RemoteShow

  def show
    section = Offer.find(params[:id]).section.identifier
    redirect_to_remote_show :angebote, section
  end
end
