# frozen_string_literal: true
module API::V1
  class TimeAllocationsController < API::V1::BackendController
    # def index
    # end

    def create
      run TimeAllocation::Create
      super
    end

    def update
      run TimeAllocation::Create
      super
    end

    def report_actual
      run TimeAllocation::ReportActual
      render json: @operation.to_json
    end
  end
end
