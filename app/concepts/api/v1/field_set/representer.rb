# frozen_string_literal: true
module API::V1
  module FieldSet
    class Show < Representable::Decorator
      include Representable::JSON

      property :column_names, getter: ->(r) do
        r[:represented].column_names
      end

      property :associations, getter: ->(r) do
        assocs = {}
        r[:represented].reflect_on_all_associations.each do |assoc|
          # INFO: Hotfixed to avoid polymorphic modules as association
          next if assoc.options[:polymorphic]
          # build association object
          class_name = assoc.options[:class_name] ? assoc.options[:class_name].underscore.pluralize : assoc.name
          key = ''
          if assoc.options[:foreign_key] && !assoc.options[:through]
            key = assoc.options[:foreign_key] ? assoc.options[:foreign_key] : assoc.active_record.to_s.underscore + '_id'
          end
          assocs[assoc.name] = {
            'columns' => assoc.klass.column_names,
            'class_name' => class_name,
            'key' => key
          }
        end
        assocs
      end
    end
  end
end
