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
  step :generate_display_name
  step Contract::Persist()

  def generate_display_name(options, model:, **)
    contract = options['contract.default']
    orga =
      contract.organization || options['nesting_operation']['contract.default']
    model.display_name = display_name(orga.name, contract)
  end

  private

  def display_name(orga_name, contract)
    display = orga_name.to_s
    display += ", #{contract.name}" if contract.name.present?
    display += " | #{contract.street}"
    display += ", #{contract.addition}," if contract.addition.present?
    display + " #{contract.zip} #{contract.city && contract.city.name}"
  end
end
