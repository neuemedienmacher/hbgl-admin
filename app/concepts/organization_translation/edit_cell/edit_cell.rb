# frozen_string_literal: true
class OrganizationTranslation::EditCell < Cell::Concept
  def show
    render
  end

  private

  include Cell::SimpleFormCell
  include Backend::FormFields::Methods

  def form &block
    simple_form_for(
      model,
      url: organization_translation_path(model.model),
      method: 'PATCH',
      &block
    )
  end

  def source_organization
    model.model.organization
  end

  def source_description
    ERB::Util.html_escape source_organization.description_de
  end
end
