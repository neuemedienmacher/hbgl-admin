# frozen_string_literal: true
# Monkeypatch clarat_base OrganizationTranslation
require ClaratBase::Engine.root.join('app', 'models', 'organization_translation')

class OrganizationTranslation < ActiveRecord::Base
  # Search
  include PgSearch
  pg_search_scope :search_everything,
                  against: [
                    :id, :organization_id, :description, :locale, :source
                  ],
                  using: { tsearch: { prefix: true } }
end
