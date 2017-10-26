# frozen_string_literal: true

class Location::Create < Trailblazer::Operation
  step Model(::Location, :new)
  step Policy::Pundit(PermissivePolicy, :create?)

  step Contract::Build(constant: Location::Contracts::Create)
  step Contract::Validate()
  step Wrap(::Lib::Transaction) {
    step ::Lib::Macros::Nested::Find(:organization, ::Organization)
    step ::Lib::Macros::Nested::Find(:city, ::City)
    step ::Lib::Macros::Nested::Find(:federal_state, ::FederalState)
  }
  step :generate_label
  step Contract::Persist()

  def generate_label(options, model:, **)
    contract = options['contract.default']
    # NOTE: only works of inline creation of location in organization
    orga_or_contract =
      contract.organization || options['nesting_operation']['contract.default']
    model.label = build_label(orga_or_contract.name, contract).first(255)
  end

  private

  def build_label(orga_name, contract)
    label = orga_name.to_s
    label += ", #{contract.name}" if contract.name.present?
    label += " | #{contract.street}"
    label += ", #{contract.addition}," if contract.addition.present?
    label + " #{contract.zip} #{contract.city && contract.city.name}"
  end
end
