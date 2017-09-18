# frozen_string_literal: true
# Monkeypatch clarat_base Topic
require ClaratBase::Engine.root.join('app', 'models', 'topic')
# Bounding Box around an Topic that a non-personal offer provides service to.
class Topic < ActiveRecord::Base
  include ReformedValidationHack

  # Search
  include PgSearch
  pg_search_scope :search_pg,
                  against: [:id, :name],
                  using: { tsearch: { prefix: true } }
end
