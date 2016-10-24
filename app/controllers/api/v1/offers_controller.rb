# frozen_string_literal: true
module API::V1
  class OffersController < API::V1::BackendController
    respond_to :json

    def index
      respond API::V1::Offer::Index
    end

    def show
      respond API::V1::Offer::Show
    end
  end
end
