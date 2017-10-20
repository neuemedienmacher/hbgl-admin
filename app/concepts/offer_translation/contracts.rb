# frozen_string_literal: true

module OfferTranslation::Contracts
  class Create < Reform::Form
    property :name
    property :description
    property :opening_specification
    property :old_next_steps
    property :source
    property :locale
    property :possibly_outdated
    property :offer_id
  end

  class Update < Create
    property :id, writeable: false
  end
end
