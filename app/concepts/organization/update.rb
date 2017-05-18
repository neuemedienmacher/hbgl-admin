# frozen_string_literal: true
class Organization::Update < Trailblazer::Operation
  step Model(::Organization, :find_by)
  step Policy::Pundit(OrganizationPolicy, :update?)

  step Contract::Build(constant: Organization::Contracts::Update)
  step Contract::Validate()
  step Contract::Persist()

  step :generate_translations!

  def generate_translations!(options, model:, **)
    changes = options['contract.default'].changed
    fields = model.translated_fields.select { |f| changes[f.to_s] }
    return true if fields.empty?
    model.generate_translations! fields
  end
end
