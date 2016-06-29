# frozen_string_literal: true
class OfferTranslation::EditCell < Cell::Concept
  def show
    render
  end

  private

  include Cell::SimpleFormCell
  include Backend::FormFields::Methods

  def form &block
    simple_form_for(model, url: offer_translation_path(model.model), &block)
  end

  def source_offer
    model.model.offer
  end

  def source_name
    ERB::Util.html_escape source_offer.name_de
  end

  def source_description
    ERB::Util.html_escape source_offer.description_de
  end

  def source_opening_specification
    ERB::Util.html_escape source_offer.opening_specification_de
  end
end
