# frozen_string_literal: true
module API::V1
  class OrganizationTranslationsController < API::V1::BackendController
    respond_to :json

    def index
      respond API::V1::OrganizationTranslation::Index
    end

    def show
      respond API::V1::OrganizationTranslation::Show
    end

    def edit
      form API::V1::OrganizationTranslation::Update
    end

    def update
      run API::V1::OrganizationTranslation::Update
      super
    end
  end
end
