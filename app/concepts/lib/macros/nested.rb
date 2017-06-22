# frozen_string_literal: true
module Lib
  module Macros
    module Nested
      def self.Find(field, klass)
        step = ->(_input, options) do
          # binding.pry if field == :federal_state
          reset_contract_field(options, field)
          each_nested_paramset(field, options) do |params|
            if params[:id]
              model = klass.find(params[:id])
              set_contract_field(options, field, model)
            else
              raise "No ID found for #{klass.name} in #{params.inspect}"
            end
          end
          true
        end
        [step, name: "nested.find.#{klass}"]
      end

      def self.Create(field, operation)
        step = ->(_input, options) do
          results = []
          reset_contract_field(options, field)
          each_nested_operation(operation, field, options) do |result|
            if result['params'][:id]
              model = result['model.class'].find(result['params'][:id]) # breaks on update?
              set_contract_field(options, field, model)
              results.push(true)
            else
              set_contract_field(options, field, result['model'])
              results.push(result)
            end
          end
          set_contract_errors(options, field, results.select { |r| r != true })
          results.all? { |r| r == true || r.success? }
        end
        [step, name: "nested.create.#{operation}"]
      end

      private_class_method

      def self.each_nested_paramset(field, options, &block)
        iterator =
          options['document'] ? :each_nested_document : :each_nested_params

        send(iterator, options, field, &block)
      end

      def self.each_nested_operation(operation, field, options)
        each_nested_paramset(field, options) do |params, document = nil|
          unless params[:id]
            params[inverse_association(options['model'], field)] = 'nested'
          end

          yield operation.(
            params,
            'current_user' => options['current_user'], 'document' => document,
            'nesting_operation' => options
          )
        end
      end

      def self.each_nested_document(options, field_name)
        parsed_document = JSON.parse(options['document'])
        document = # assuming JSONAPI
          parsed_document['data']['relationships'] &&
          parsed_document['data']['relationships'][field_name.to_s.dasherize]

        return unless document
        if document['data'].is_a? Array
          document['data'].each do |single_document|
            completed_single_document = { data: single_document }.to_json
            nested_params = params_from_document(single_document)
            yield nested_params, completed_single_document
          end
        else
          yield params_from_document(document['data']), document.to_json
        end
      end

      def self.each_nested_params(options, field_name)
        relationship = options['params'][field_name]

        if relationship.is_a? Array
          relationship.each do |single_relationship|
            next unless single_relationship
            yield single_relationship
          end
        elsif relationship
          yield relationship
        end
      end

      def self.params_from_document(document)
        params = {}
        if document['id']
          params[:id] = document['id']
        else
          document['attributes'].each do |field, value|
            params[field.underscore.to_sym] = value
          end
          document['relationships']&.each do |relation_name, data|
            symbolized_name = relation_name.underscore.to_sym
            if is_iterable?(data['data'])
              params[relation_name.underscore.to_sym] = []
              data['data'].each do |datum|
                params[symbolized_name].push(params_from_document(datum))
              end
            else
              params[symbolized_name] = params_from_document(data['data'])
            end
          end
        end
        params
      end

      def self.reset_contract_field(options, field_name)
        field_value = options['contract.default'].send(field_name)
        if is_iterable?(field_value)
          options['contract.default'].send(:"#{field_name}=", [])
        elsif !field_value.is_a? Hash
          options['contract.default'].send(:"#{field_name}=", nil)
        end
      end

      def self.set_contract_field(options, field_name, field_value)
        if is_iterable?(options['contract.default'].send(field_name))
          options['contract.default'].send(field_name).push(field_value)
        else
          options['contract.default'].send(:"#{field_name}=", field_value)
        end
      end

      def self.set_contract_errors(options, field_name, results)
        if is_iterable?(options['contract.default'].send(field_name))
          error = {}
          results.each_with_index do |result, index|
            current_error = error_from_result(result)
            error[index] = current_error if current_error
          end
          add_contract_error options, field_name, error
        else
          add_contract_error options, field_name, error_from_result(results[0])
        end
      end

      def self.add_contract_error(options, field_name, error)
        return if !error || error.none?
        options['contract.default'].errors.add(field_name, error)
      end

      def self.error_from_result(result)
        return unless result
        error = result['contract.default'].errors.to_h
        if error.none?
          if result.success?
            nil
          else
            'Operation Failure'
          end
        else
          error
        end
      end

      # def self.relevant_contract_errors parent_contract, field, nested_contract
      #   error = nested_contract.errors.to_h
      #   error
      # end

      def self.inverse_association(model, field)
        model.association(field).reflection.inverse_of.name
      end

      def self.is_iterable?(instance)
        instance.is_a?(Array) ||
          instance.is_a?(ActiveRecord::Associations::CollectionProxy)
      end
    end
  end
end
