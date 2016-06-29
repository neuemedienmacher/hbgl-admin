module Backend::FormFields
  module Methods
  def string_field f, field
    field_cell :string, f, field
  end

  def textarea f, field
    field_cell :textarea, f, field
  end

  def filtering_select_field f, field
    field_cell :filtering_select, f, field
  end

  def filtering_multiselect_field f, field
    field_cell :filtering_multiselect, f, field
  end

  protected

  def field_cell field_type, f, field
    concept 'backend/form_fields/field_cell', model,
            as: field_type, f: f, field: field
  end
end
end
