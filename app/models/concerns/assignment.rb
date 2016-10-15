# frozen_string_literal: true
# Monkeypatch clarat_base Assignment
require ClaratBase::Engine.root.join('app', 'models', 'assignment')

class Assignment < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search_everything,
                  against: [
                    :id, :message, :assignable_type, :assignable_field_type
                  ],
                  using: { tsearch: { prefix: true } }

  ASSIGNABLE_MODELS = %w(OfferTranslation).freeze

  # TODO: this should be dynamic (based on field_set of model)
  # ASSIGNABLE_FIELD_NAMES = {
  #   'OfferTranslation' => %w(name description opening_specification)
  # }.freeze
end
