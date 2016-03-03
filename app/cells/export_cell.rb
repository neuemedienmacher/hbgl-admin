require 'simple_form'

class ExportCell < Cell::ViewModel
  def show
    render :new
  end

  private

  ### Form helpers ###

  include ActionView::Helpers::FormHelper
  include SimpleForm::ActionViewExtensions::FormHelper

  def dom_class(record, prefix = nil)
    ActionView::RecordIdentifier.dom_class(record, prefix)
  end

  def dom_id(record, prefix = nil)
    ActionView::RecordIdentifier.dom_id(record, prefix)
  end

  ### / Form helpers ###

  def form &block
    simple_form_for(model, url: exports_path(object_name: 'offer'), &block)
  end

  def columns
    model.model.column_names.map do |column|
      [column, column.titleize]
    end
  end
end
