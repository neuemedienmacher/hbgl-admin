# frozen_string_literal: true
module API::V1
  class OfferTranslationsController < API::V1::BackendController
    skip_before_action :authenticate_user!
    respond_to :json

    def index
      respond API::V1::OfferTranslation::Index
    end

    def show
      respond OfferTranslation::Show
    end

    def update
      run OfferTranslation::Update
      super
    end
  end
end
