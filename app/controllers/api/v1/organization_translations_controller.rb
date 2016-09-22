# frozen_string_literal: true
module API::V1
  class OrganizationTranslationsController < API::V1::BackendController
    skip_before_action :authenticate_user!
    respond_to :json

    def index
      respond API::V1::OrganizationTranslation::Index
    end

    def show
      respond OrganizationTranslation::Show
    end

    def update
      run OrganizationTranslation::Update
      super
    end
  end
end
