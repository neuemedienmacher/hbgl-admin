# frozen_string_literal: true
module API::V1
  class WebsitesController < API::V1::BackendController
    skip_before_action :authenticate_user!
    respond_to :json

    def index
      respond API::V1::Website::Index
    end
  end
end
