# frozen_string_literal: true
class TimeAllocation::ReportActual < Trailblazer::Operation
  step :TODO_model!
  step Policy::Pundit(TimeAllocationPolicy, :report_actual?)

  step Contract::Build()
  step Contract::Validate()
  step Contract::Persist()
  step :side_effects!

  extend Contract::DSL
  contract do
    property :actual_wa_hours
    property :actual_wa_comment
    validates :actual_wa_hours, presence: true, numericality: true
  end

  def model!(params)
    TimeAllocation::DynamicFind.new(*essential_parameters)
      .find_or_initialize
  end

  def side_effects!
    ::Statistic::WeeklyStatisticAggregator.new(
      *essential_parameters,
      @params['data']['attributes']['actual_wa_hours']
    ).record!
  end

  def essential_parameters
    [
      @params[:current_user].id, @params[:year], @params[:week_number]
    ]
  end
end
