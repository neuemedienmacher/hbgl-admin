# frozen_string_literal: true

class Area::Create < Trailblazer::Operation
  step :match_or_new
  step Policy::Pundit(PermissivePolicy, :create?)

  step Contract::Build(constant: Area::Contracts::Create)
  step Contract::Validate()
  step Contract::Persist()

  def match_or_new(options, params:, **)
    puts("match_or_new in create.rb area")
    puts params
    options['model.class'] = Area
    options['model'] =
      Area.find_by(id: params[:id]) || Area.new
  end
end
