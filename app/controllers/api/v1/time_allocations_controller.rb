# frozen_string_literal: true
module API::V1
  class TimeAllocationsController < API::V1::BackendController
    def report_actual
      endpoint TimeAllocation::ReportActual, { args: api_args }, &default_endpoints
    end
  end
end
