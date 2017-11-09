# frozen_string_literal: true

module API::V1
  module FieldSet
    class Show < Representable::Decorator
      include Representable::JSON

      property :columns, getter: ->(r) do
        columns = []
        r[:represented].columns.each do |col|
          options =
            if col.type == :boolean
              %w[true false]
            elsif col.name == 'aasm_state'
              r[:represented].aasm.states.map(&:name)
            elsif r[:represented].methods.include?(:enumerized_attributes)
              r[:represented].enumerized_attributes[col.name]&.values
            else
              []
            end
          columns << {
            'name' => col.name.dasherize,
            'type' => col.type,
            'options' => options
          }
        end
        columns
      end

      property :associations, getter: ->(r) do
        def filter_name_for_association(assoc)
          if ignored_association?(assoc)
            ['']
          elsif inverse_is_polymorphic?(assoc)
            polymorphic_filter_for assoc
          else
            filter_for assoc
          end
        end

        def ignored_association?(assoc)
          (!assoc.options[:inverse_of] && !assoc.options[:as]) ||
            assoc.options[:polymorphic].present?
        end

        def polymorphic_inverse_assoc(assoc)
          assoc.options[:as] &&
            assoc.class_name.constantize.reflect_on_all_associations
                 .find { |a| a.name == assoc.options[:as] }
        end

        def inverse_is_polymorphic?(assoc)
          # old: assoc.options[:inverse_of].to_s.ends_with?('able')
          polymorphic_inverse_assoc(assoc)&.polymorphic? || false
        end

        def polymorphic_filter_for assoc
          polymorphic_name = polymorphic_inverse_assoc(assoc).name
          ["#{polymorphic_name}_id", "#{polymorphic_name}_type"]
        end

        def filter_for assoc
          name = assoc.options[:inverse_of]
          prefix = prefix_for(assoc, name)
          [plural?(name) ? "#{name}.id" : "#{prefix}#{name.to_s.singularize}_id"]
        end

        def prefix_for assoc, name
          if assoc.options[:through] && plural?(name) == false
            assoc.options[:through].to_s.singularize + '.'
          else
            ''
          end
        end

        def plural? input
          input.to_s == input.to_s.pluralize
        end

        assocs = {}
        r[:represented].reflect_on_all_associations.each do |assoc|
          # NOTE: Hotfixed to avoid polymorphic modules as association
          next if assoc.options[:polymorphic]
          # build association object
          class_name =
            if assoc.options[:class_name]
              assoc.options[:class_name].underscore.pluralize
            else
              assoc.name
            end
          keys = filter_name_for_association(assoc)
          assocs[assoc.name] = {
            'columns' => assoc.klass.column_names.map(&:dasherize),
            'class-name' => class_name,
            'key' => keys
          }
        end
        assocs
      end
    end
  end
end
