# frozen_string_literal: true
module API::V1
  class OffersController < API::V1::BackendController
    respond_to :json

    def index
      respond Offer::Index
    end

    def show
      respond Offer::Show
    end
  end
end
