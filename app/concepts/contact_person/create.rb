# frozen_string_literal: true

class ContactPerson::Create < Trailblazer::Operation
  step Model(::ContactPerson, :new)
  step Policy::Pundit(PermissivePolicy, :create?)

  step Contract::Build(constant: ContactPerson::Contracts::Create)
  step Contract::Validate()
  step Wrap(::Lib::Transaction) {
    step ::Lib::Macros::Nested::Find(:organization, ::Organization)
    step ::Lib::Macros::Nested::Create(:email, ::Email::Create)
  }
  step Contract::Persist()
  step :generate_label

  # For rails_admin display
  def generate_label(options, model:, **)
    contract = options['contract.default']
    position_label = position_label(contract)
    label = if contract.first_name.blank? && contract.last_name.blank?
              "#{position_label}##{contract.id} #{contract.operational_name} "
            else
              "#{position_label}##{contract.id} #{contract.first_name}"\
              " #{contract.last_name} "
            end
    model.update_columns label: label + label_suffix(contract)
  end

  def label_suffix(contract)
    "(#{contract.organization&.name}) #{contract.email&.address}"\
    " #{contract.area_code_1} #{contract.local_number_1}".squeeze(' ')
  end

  def position_label(contract)
    if contract.position.present?
      I18n.t("enumerize.contact_person.position.#{contract.position}") + ': '
    else
      ''
    end
  end
end
