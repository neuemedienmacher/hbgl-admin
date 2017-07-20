# frozen_string_literal: true
class Organization::Update < Trailblazer::Operation
  step Model(::Organization, :find_by)
  step Policy::Pundit(OrganizationPolicy, :update?)

  step ::Lib::Macros::State::Contract(
    approve: Organization::Contracts::Approve,
    else: Organization::Contracts::Update
  )
  step Contract::Build()
  step Contract::Validate()
  step Wrap(::Lib::Transaction) {
    step ::Lib::Macros::Nested::Create :website, Website::Create
    step ::Lib::Macros::Nested::Create :divisions, Division::Create
    step ::Lib::Macros::Nested::Create :contact_people, ContactPerson::Create
    step ::Lib::Macros::Nested::Create :locations, Location::Create
    step ::Lib::Macros::Nested::Find :umbrella_filters, ::UmbrellaFilter
  }
  step :change_state_side_effect # prevents persist on faulty state change
  # step ::Lib::Macros::Debug::Breakpoint()
  step Contract::Persist()
  step :generate_translations!

  def change_state_side_effect(options, model:, params:, **)
    return true unless params['meta'] && params['meta']['commit']
    result = ::Organization::ChangeState.(
      { id: model.id }, 'event' => params['meta']['commit']
    )
    # add errors of side-effect operation to the errors of this operation
    if result.success?
      options['changed_state'] = true
      options['model'] = result['model']
    else
      add_all_errors(result['contract.default'], options['contract.default'])
    end
    result.success?
  end

  def generate_translations!(options, changed_state: false, model:, params:, **)
    changes = options['contract.default'].changed
    fields = model.translated_fields.select { |f| changes[f.to_s] }
    meta = params['meta'] && params['meta']['commit']
    if (meta.to_s == 'approve' && changed_state) || fields.any?
      model.generate_translations! fields.any? ? fields : :all
    end
    true
  end

  ### non-step functions ###

  def add_all_errors(from_contract, to_contract)
    from_contract.errors.each do |key, message|
      to_contract.errors.add(key, message)
    end
  end
end
