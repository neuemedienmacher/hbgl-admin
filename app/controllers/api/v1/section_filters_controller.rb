# frozen_string_literal: true
module API::V1
  class SectionFiltersController < API::V1::BackendController
    respond_to :json

    def index
      respond Filter::SectionFilter::Index
    end
  end
end
