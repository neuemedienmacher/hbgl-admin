module Cell
  module SimpleFormCell
    require 'simple_form'

    ### Form Rendering helpers ###

    include ActionView::Helpers::FormHelper
    include ActionView::Helpers::FormOptionsHelper
    include SimpleForm::ActionViewExtensions::FormHelper

    def dom_class(record, prefix = nil)
      ActionView::RecordIdentifier.dom_class(record, prefix)
    end

    def dom_id(record, prefix = nil)
      ActionView::RecordIdentifier.dom_id(record, prefix)
    end

    ### / Form Rendering helpers ###
  end
end
