# frozen_string_literal: true
class Offer::NewCell < Cell::Concept
  property :name

  def show
    render
  end

  private

  include Cell::SimpleFormCell
  include Backend::FormFields::Methods

  def form &block
    simple_form_for(model, url: offers_path, &block)
  end
end
