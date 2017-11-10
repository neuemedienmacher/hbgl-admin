# frozen_string_literal: true

# rubocop:disable Metrics/ModuleLength
module Lib
  module Macros
    module Nested
      def self.Find(field, klass)
        step = ->(_input, options) do
          each_nested(:paramset, field, options) do |params|
            if params[:id]
              [klass.find(params[:id]), true]
            else
              raise "No ID found for #{klass.name} in #{params.inspect}"
            end
          end
        end
        [step, name: "nested.find.#{klass}"]
      end

      def self.Create(field, operation)
        step = ->(_input, options) do
          each_nested(:operation, field, options, [operation]) do |result|
            if result['params'][:id]
              # breaks on update?
              [result['model.class'].find(result['params'][:id]), true]
            else
              [result['model'], result]
            end
          end
        end
        [step, name: "nested.create.#{operation}"]
      end

      private_class_method

      def self.each_nested iterator_suffix, field, options, iterator_attrs = []
        results = []
        reset_contract_field(options, field) if nested_given?(field, options)
        send(
          "each_nested_#{iterator_suffix}", field, options, *iterator_attrs
        ) do |response|
          settable, pushable = yield response
          set_contract_field(options, field, settable)
          results.push pushable
        end
        set_contract_errors(options, field, results.reject { |r| r == true })
        results.all? { |r| r == true || r.success? }
      end

      def self.nested_given?(field, options)
        (options['params'] && options['params'][field]) ||
          (options['document'] && parsed_document(options['document'], field))
      end

      def self.each_nested_paramset(field, options, &block)
        iterator =
          options['document'] ? :each_nested_document : :each_nested_params

        send(iterator, field, options, &block)
      end

      def self.each_nested_operation(field, options, operation)
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

      def self.each_nested_document(field_name, options)
        document = parsed_document(options['document'], field_name)
        return unless document
        if document['data'].is_a? Array
          document['data'].each do |single_document|
            completed_single_document = { data: single_document }.to_json
            nested_params = params_from_document(single_document)
            yield nested_params, completed_single_document
          end
        elsif document.any?
          yield params_from_document(document['data']), document.to_json
        end
      end

      def self.parsed_document(json_document, field_name)
        parsed = JSON.parse(json_document)

        # assuming JSONAPI
        parsed['data']['relationships'] &&
          parsed['data']['relationships'][field_name.to_s.dasherize]
      end

      def self.each_nested_params(field_name, options)
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

      def self.params_from_document(doc)
        return { id: doc['id'] } if doc['id']

        params = {}
        doc['attributes'].each do |field, value|
          params[field.underscore.to_sym] = value
        end
        params.merge!(
          doc['relationships']&.map(
            &method(:params_from_document_relationships)
          )&.select { |array| !array[1].nil? }.to_h || {}
        )
        params
      end

      def self.params_from_document_relationships(relationship)
        relation_name, data = relationship
        symbolized_name = relation_name.underscore.to_sym
        value = nil
        if iterable?(data['data'])
          value = []
          data['data'].each { |datum| value.push(params_from_document(datum)) }
        elsif data['data']
          value = params_from_document(data['data'])
        end
        [symbolized_name, value]
      end

      def self.reset_contract_field(options, field_name)
        field_value = options['contract.default'].send(field_name)
        without_changes(options['contract.default']) do
          if iterable?(field_value)
            options['contract.default'].send(:"#{field_name}=", [])
          elsif !field_value.is_a? Hash
            options['contract.default'].send(:"#{field_name}=", nil)
          end
        end
      end

      def self.set_contract_field(options, field_name, field_value)
        without_changes(options['contract.default']) do
          if iterable?(options['contract.default'].send(field_name))
            options['contract.default'].send(field_name).push(field_value)
          else
            options['contract.default'].send(:"#{field_name}=", field_value)
          end
        end
      end

      def self.without_changes(contract)
        original_changes = contract.instance_variable_get(:"@_changes").dup
        yield
        contract.instance_variable_set(:"@_changes", original_changes)
      end

      def self.set_contract_errors(options, field_name, results)
        if iterable?(options['contract.default'].send(field_name))
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
        error = result['contract.default']&.errors.to_h
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

      def self.inverse_association(model, field)
        model.association(field).reflection.inverse_of.name
      end

      def self.iterable?(instance)
        instance.is_a?(Array) ||
          instance.is_a?(ActiveRecord::Associations::CollectionProxy)
      end
    end
  end
end
# rubocop:enable Metrics/ModuleLength
