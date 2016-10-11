# frozen_string_literal: true
module API::V1
  module FieldSet
    class Show < Roar::Decorator
      include Roar::JSON

      property :column_names, getter: ->(r) do
        r[:represented].column_names
      end

      property :associations, getter: ->(r) do
        assocs = {}
        r[:represented].reflect_on_all_associations.each do |assoc|
            # INFO: Hotfixed to avoid polymorphic modules as association
          unless assoc.options[:polymorphic]
            # add class_name to hash (custom named validations)
            class_name = assoc.options[:class_name] ? assoc.options[:class_name].underscore.pluralize : assoc.name
            assocs[assoc.name] = {'columns' => assoc.klass.column_names, 'class_name' => class_name}
          end
        end
        assocs
      end
    end
  end
end
