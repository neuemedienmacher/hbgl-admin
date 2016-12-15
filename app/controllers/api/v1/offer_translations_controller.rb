# frozen_string_literal: true
module API::V1
  class OfferTranslationsController < API::V1::BackendController
    skip_before_action :authenticate_user!
    respond_to :json

    def index
      respond API::V1::OfferTranslation::Index
    end

    def show
      respond API::V1::OfferTranslation::Show
    end

    def edit
      form API::V1::OfferTranslation::Update
    end

    def update
      run API::V1::OfferTranslation::Update
      super
    end
  end
end
