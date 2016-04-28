module Backend::FormFields
  class FieldCell < Cell::Concept
    def show
      render
    end

    private

    def field
      concept "backend/form_fields/#{options[:as]}_cell", model, options
    end

    def field_label
      options[:f].label field_name, class: 'col-sm-2 control-label'
    end

    def wrapper_class
      "#{field_name}_field"
    end

    def field_name
      options[:field]
    end
  end
end
