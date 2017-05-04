# frozen_string_literal: true
# Monkeypatch clarat_base Section
require ClaratBase::Engine.root.join('app', 'models', 'section')

class Section < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search_everything,
                  against: [:id, :name, :identifier],
                  using: { tsearch: { prefix: true } }
end
