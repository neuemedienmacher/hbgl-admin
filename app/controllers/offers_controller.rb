# frozen_string_literal: true
class OffersController < BackendController
  include RemoteShow

  def show
    redirect_to_remote_show :angebote
  end

  # def new
  #   form Offer::Create
  # end
  #
  # def create
  #   run Offer::Create
  # end
end
