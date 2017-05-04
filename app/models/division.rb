# frozen_string_literal: true
# Monkeypatch clarat_base Division
require ClaratBase::Engine.root.join('app', 'models', 'division')

class Division < ActiveRecord::Base
  # Search
  include PgSearch
  pg_search_scope :search_everything,
                  against: [ :id, :name ],
                  using: { tsearch: { prefix: true } }

  # Methods
end
