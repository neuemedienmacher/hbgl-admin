# frozen_string_literal: true
module API::V1
  module TimeAllocation
    class ReportActual < ::TimeAllocation::ReportActual
      extend Trailblazer::Operation::Representer::DSL
      representer API::V1::TimeAllocation::Representer::Show
    end
  end
end
