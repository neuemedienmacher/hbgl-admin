# frozen_string_literal: true
class Website::Create < Trailblazer::Operation
  step :match_or_new
  step Policy::Pundit(WebsitePolicy, :create?)

  step Contract::Build(constant: Website::Contracts::Create)
  step Contract::Validate()
  step Contract::Persist()

  # TODO: refactor to Macro
  def match_or_new(options, params:, **)
    options['model'] =
      Website.find_by(host: params[:host], url: params[:url]) || Website.new
  end
end
