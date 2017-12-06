# frozen_string_literal: true

class Email::Create < Trailblazer::Operation
  step :match_or_new
  step Policy::Pundit(PermissivePolicy, :create?)

  step Contract::Build(constant: Email::Contracts::Create)
  step Contract::Validate()
  step Contract::Persist()

  # TODO: refactor to Macro
  def match_or_new(options, params:, **)
    options['model.class'] = Email
    options['model'] =
      Email.find_by(address: params[:address]) || Email.new
  end
end
