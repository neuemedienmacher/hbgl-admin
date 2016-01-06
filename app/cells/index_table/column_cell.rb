module IndexTable
  class ColumnCell < Cell::ViewModel
    builds do |model, options|
      # Switch between different ways of displaying the cell content
      case model
      when String, Integer, NilClass
        ColumnCell
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
        cell('index_table/association_column', element)
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
