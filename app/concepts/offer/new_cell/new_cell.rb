# frozen_string_literal: true
class Offer::NewCell < Cell::Concept
  property :name

  def show
    render
  end

  private

  include Cell::SimpleFormCell

  def form &block
    simple_form_for(model, url: offers_path, &block)
  end

  def string_field f, field
    concept 'backend/form_fields/field_cell', model,
            as: :string, f: f, field: field
  end

  def filtering_select_field f, field
    concept 'backend/form_fields/field_cell', model,
            as: :filtering_select, f: f, field: field
  end

  def filtering_multiselect_field f, field
    concept 'backend/form_fields/field_cell', model,
            as: :filtering_multiselect, f: f, field: field
  end
end
