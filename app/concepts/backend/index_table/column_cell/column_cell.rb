# frozen_string_literal: true
module Backend::IndexTable
  class ColumnCell < Cell::Concept
    builds do |model, _options|
      # Switch between different ways of displaying the cell content
      case model
      when Integer, NilClass
        ColumnCell
      when String
        StringColumnCell
      when TrueClass, FalseClass
        BooleanColumnCell
      when ActiveRecord::Associations::CollectionProxy
        CollectionColumnCell
      else
        AssociationColumnCell
      end
    end

    def show # this handles the column content being simply renderable
      model
    end
  end

  class StringColumnCell < ColumnCell
    def show
      model.truncate(40)
    end
  end

  class BooleanColumnCell < ColumnCell
    def show
      render :boolean
    end

    def active?
      model
    end
  end

  class CollectionColumnCell < ColumnCell
    def show
      model.map do |element|
        concept('backend/index_table/association_column_cell', element)
      end.join(', ')
    end
  end

  class AssociationColumnCell < ColumnCell
    def show
      model.try(:display_name) || model.try(:name) ||
        raise("#{model} needs display_name")
    end
  end
end
