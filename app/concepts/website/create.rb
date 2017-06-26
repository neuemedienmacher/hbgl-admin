# frozen_string_literal: true
class Website::Create < Trailblazer::Operation
  step :match_or_new
  step Policy::Pundit(WebsitePolicy, :create?)

  step Contract::Build(constant: Website::Contracts::Create)
  step Contract::Validate()
  step Contract::Persist()

  # TODO: refactor to Macro
  def match_or_new(options, **)
    options['model'] =
      begin
        params = options['params'].select { |key, value| value != 'nested' }
        Website.find_by(params)
      rescue ActiveRecord::RecordNotFound
        Website.new
      end
  end
end
