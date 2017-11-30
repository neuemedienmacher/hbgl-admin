# frozen_string_literal: true

# Monkeypatch clarat_base Division
require ClaratBase::Engine.root.join('app', 'models', 'division')

class Division < ApplicationRecord
  # Search
  include PgSearch
  pg_search_scope :search_pg,
                  against: %i[id addition size label],
                  using: { tsearch: { prefix: true } }

  def event_possible?(event)
    (event.eql?(:mark_as_not_done) && self.done) ||
      (event.eql?(:mark_as_done) && !self.done && self.organization.approved?)
  end
end
