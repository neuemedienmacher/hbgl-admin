class OffersController < ApplicationController
  include RemoteShow

  def show
    redirect_to_remote_show :angebote
  end

  def index
    @offers = Offer.limit(20)
    @offers = @offers.order("#{params[:sort]} ASC") if params[:sort]
  end

  def new
    form Offer::Create
  end
end
