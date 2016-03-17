require 'simple_form'

class Export::Cell < Cell::Concept
  def show
    render :new
  end

  private

  ### Form Rendering helpers ###

  include ActionView::Helpers::FormHelper
  include SimpleForm::ActionViewExtensions::FormHelper

  def dom_class(record, prefix = nil)
    ActionView::RecordIdentifier.dom_class(record, prefix)
  end

  def dom_id(record, prefix = nil)
    ActionView::RecordIdentifier.dom_id(record, prefix)
  end

  ### / Form Rendering helpers ###

  def form &block
    simple_form_for(model, url: exports_path(object_name: object_name), &block)
  end

  def object_name
    model.model.object.name.downcase
  end

  def base_columns
    columns_for(model.model.object)
  end

  def columns_for(active_record_model)
    active_record_model.column_names.map do |column|
      [column, column.titleize]
    end
  end

  def associations
    model.model.object.reflect_on_all_associations()
  end

  def columns_for_association association
    columns_for(association.klass)
  end
end
