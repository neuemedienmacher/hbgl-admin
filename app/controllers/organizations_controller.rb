class OffersController < ApplicationController
  include RemoteShow

  def show
    redirect_to_remote_show :organizations
  end
end
