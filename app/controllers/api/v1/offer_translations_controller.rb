# frozen_string_literal: true
module API::V1
  class OfferTranslationsController < API::V1::BackendController
    respond_to :json

    # Add the "changes_by_human" for operation calls made by this controller
    def api_args
      args = super
      args[1]['changes_by_human'] = true
      args
    end
  end
end
