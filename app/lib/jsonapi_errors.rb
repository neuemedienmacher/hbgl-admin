# frozen_string_literal: true
module JsonapiErrors
  def self.generate operation_result
    error_hash = { errors: [] }
    error_hash = add_authentication_errors(operation_result, error_hash)
    error_hash = add_contract_errors(operation_result, error_hash)
    error_hash
  end

  private_class_method

  def self.add_authentication_errors result, error_hash
    if result['result.policy.default'] &&
       result['result.policy.default']['message']
      error_hash[:errors].push title: result['result.policy.default']['message']
    end
    error_hash
  end

  def self.add_contract_errors result, error_hash
    if result['contract.default']
      result['contract.default'].errors.each_entry do |field, message|
        dashed = field.to_s.dasherize
        error_hash[:errors].push(
          title: message, source: { pointer: "/data/attributes/#{dashed}" }
        )
      end
    end
    error_hash
  end
end
