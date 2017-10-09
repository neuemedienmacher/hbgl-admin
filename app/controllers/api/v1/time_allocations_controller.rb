# frozen_string_literal: true

module API::V1
  class TimeAllocationsController < API::V1::BackendController
    def report_actual
      custom_endpoint TimeAllocation::ReportActual.(*api_args), 200
    end
  end
end
