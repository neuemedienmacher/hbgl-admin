# frozen_string_literal: true
module API::V1
  module TimeAllocation
    class ReportActual < Trailblazer::Operation
      include Trailblazer::Operation::Representer, Responder
      representer Representer::Show

      include Trailblazer::Operation::Policy
      policy TimeAllocationPolicy, :report_actual?

      contract do
        property :actual_wa_hours
        property :actual_wa_comment
        validates :actual_wa_hours, presence: true, numericality: true
      end

      def model!(params)
        TimeAllocation::DynamicFind.new(*essential_parameters)
          .find_or_initialize
      end

      def process(params)
        if validate(params[:json], model)
          contract.save
          side_effects!
        else
          raise 'TimeAllocation report has errors, which should not happen'\
                "with our user base: #{contract.errors.full_messages}"
        end
      end

      def side_effects!
        ::Statistic::WeeklyStatisticAggregator.new(
          *essential_parameters,
          @params['data']['attributes']['actual_wa_hours']
        ).record!
      end

      def essential_parameters
        [
          @params[:current_user].id, @params[:year], @params[:week_number],
        ]
      end
    end
  end
end
