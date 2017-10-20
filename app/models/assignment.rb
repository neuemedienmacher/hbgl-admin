# frozen_string_literal: true

# Monkeypatch clarat_base Assignment
require ClaratBase::Engine.root.join('app', 'models', 'assignment')
class Assignment < ApplicationRecord
  include PgSearch
  pg_search_scope :search_pg,
                  against: %i[
                    id message assignable_type assignable_field_type
                    message
                  ],
                  using: { tsearch: { prefix: true } }
  # Only used by NewAssignment Form - can be removed when the form is obsolete
  ASSIGNABLE_MODELS =
    %w[OfferTranslation OrganizationTranslation Division Organization].freeze

  # TODO: this should be dynamic (based on field_set of model)
  # ASSIGNABLE_FIELD_NAMES = {
  #   'OfferTranslation' => %w(name description opening_specification)
  # }.freeze
end
