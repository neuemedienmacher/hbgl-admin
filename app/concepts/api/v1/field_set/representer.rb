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
          assocs[assoc.name] = assoc.klass.column_names
        end
        assocs
      end
    end
  end
end
