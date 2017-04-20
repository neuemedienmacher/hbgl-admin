# frozen_string_literal: true
# Monkeypatch clarat_base Filter
require ClaratBase::Engine.root.join('app', 'models', 'filter')

class Filter < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search_everything,
                  against: [:id, :name, :identifier],
                  using: { tsearch: { prefix: true } }

  include ReformedValidationHack
end
