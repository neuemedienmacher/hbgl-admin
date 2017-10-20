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
      each_serialized_error(result['contract.default'].errors) do |msg, pointer|
        error_hash[:errors].push(
          title: msg, source: { pointer: pointer }
        )
      end
    end
    error_hash
  end

  def self.each_serialized_error(errors, &block)
    errors.each_entry { |key, value| recursive_serialize(key, value, &block) }
  end

  # rubocop:disable Metrics/MethodLength
  def self.recursive_serialize(
    key, value, pointer_array = [''], index = false, &block
  )
    # if key is integer => nest with index = key
    if key.is_a?(Integer)
      return value.each do |inner_key, inner_value|
        recursive_serialize(
          inner_key, inner_value, pointer_array.clone, key, &block
        )
      end
    end
    key = key.to_s.dasherize

    # always starts with data, followed by optional index
    pointer_array.push('data')
    pointer_array.push(index) if index

    if value.is_a?(Hash) # is a relationship and needs further nesting
      pointer_array.push('relationships', key)
      value.each do |inner_key, inner_value|
        recursive_serialize(inner_key, inner_value, pointer_array, &block)
      end
    else # value is attribute, can be yielded
      pointer_array.push('attributes', key)
      yield_serialized_error(value, pointer_array, &block)
    end
  end
  # Example: recursive_serialize(:deep, 0 => { deeper: { deepest: 'bla' })
  # => /data/relationsips/deep | 0 => { deeper: { ... } } [no index]
  # => [skip] | deeper: { deepest: 'bla' } [index = 0]
  # +> /data/0/relationships/deeper | deepest: 'bla' [no index]
  # +> /data/attributes/deepest
  # rubocop:enable Metrics/MethodLength

  def self.yield_serialized_error value, pointer_array, &_block
    pointer = pointer_array.join '/'

    if value.is_a?(Array)
      value.each do |message|
        yield message, pointer
      end
    else
      yield value, pointer
    end
  end
end
