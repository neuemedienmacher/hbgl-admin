# frozen_string_literal: true
module NestedValidation
  def self.included base
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def validate_nested property_name, contract
      validate -> do
        property_value = send(property_name)
        if property_value
          validate_single_nested(property_name, property_value, contract)
        end
      end
    end

    def validate_nested_collection property_name, contract
      validate -> do
        property_value_array = send(property_name)
        if property_value_array.any?
          property_value_array.each_with_index do |value, index|
            validate_single_nested property_name, value, contract, index
          end
        end
      end
    end
  end

  module InstanceMethods
    protected

    def validate_single_nested name, value, contract, index = nil
      contract_instance = contract.new(value)
      unless contract_instance.valid?
        add_nested_errors(contract_instance, name, index)
      end
    end

    def add_nested_errors(contract_instance, name, index)
      error = contract_instance.errors.to_h

      # ignore inverse validation errors (like missing presence)
      association_name = model.association(name).reflection.inverse_of.name
      error.delete(association_name)
      return unless error.any? # cancel if that was the only error

      # add optional index to error
      if index
        error = (errors.to_h[name] || {}).merge(index => error)
      end
      errors.add(name, error)
    end
  end
end
