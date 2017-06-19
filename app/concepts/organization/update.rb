# frozen_string_literal: true
class Organization::Update < Trailblazer::Operation
  step Model(::Organization, :find_by)
  step Policy::Pundit(OrganizationPolicy, :update?)

  step Contract::Build(constant: Organization::Contracts::Update)
  step Contract::Validate()
  step Contract::Persist()
  # step :change_state_side_effect
  step :generate_translations!

  def generate_translations!(options, model:, **)
    changes = options['contract.default'].changed
    fields = model.translated_fields.select { |f| changes[f.to_s] }
    return true if fields.empty?
    model.generate_translations! fields
  end

  # def change_state_side_effect(_, model:, params:, **)
  #   state_event = params['meta']['commit']
  #   return true unless state_event # && model.send("may_#{state_event}?")
  #   result = ::Organization::ChangeState.(
  #     { id: model.id }, 'event' => state_event
  #   )
  #   # add errors of side-effect operation to the errors of this operation
  #   if !result.success?
  #     result['contract.default'].errors.messages.map do |key, values|
  #       values.map do |value|
  #         self['contract.default'].errors.add(key, value)
  #       end
  #     end
  #   end
  #   result.success?
  # end
end
