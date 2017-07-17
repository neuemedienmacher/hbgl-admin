# frozen_string_literal: true
module OrganizationTranslation::Contracts
  class Create < Reform::Form
    property :description
    property :source
    property :possibly_outdated
    property :locale
    property :organization_id
  end

  class Update < Create
    property :id, writeable: false
  end
end
