# frozen_string_literal: true
module API::V1
  class SectionFiltersController < API::V1::BackendController
    def index_operation
      API::V1::Filter::Index::SectionFilter
    end

    def show_representer
      API::V1::Filter::Representer::Show
    end
  end
end
