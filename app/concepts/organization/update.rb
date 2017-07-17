# frozen_string_literal: true
class Organization::Update < Trailblazer::Operation
  step Model(::Organization, :find_by)
  step Policy::Pundit(OrganizationPolicy, :update?)

  step Contract::Build(constant: Organization::Contracts::Update)
  step Contract::Validate()
  step :change_state_side_effect
  step Contract::Persist()
  step :generate_translations!

  def generate_translations!(options, changed_state: false, model:, params:, **)
    changes = options['contract.default'].changed
    fields = model.translated_fields.select { |f| changes[f.to_s] }
    meta = params['meta'] && params['meta']['commit']
    return true if fields.empty? || (!changed_state && meta == 'approve')
    model.generate_translations! fields
  end

  def change_state_side_effect(options, model:, params:, **)
    return true unless params['meta'] && params['meta']['commit']
    result = ::Organization::ChangeState.(
      { id: model.id }, 'event' => params['meta']['commit']
    )
    # add errors of side-effect operation to the errors of this operation
    if result.success?
      options['changed_state'] = true
    else
      result['contract.default'].errors.each_pair do |key, message|
        options['contract.default'].errors.add(key, message)
      end
    end
    result.success?
  end
end
