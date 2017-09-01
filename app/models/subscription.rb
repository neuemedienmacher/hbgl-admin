# frozen_string_literal: true
# Monkeypatch clarat_base subscription
require ClaratBase::Engine.root.join('app', 'models', 'subscription')
class Subscription < ActiveRecord::Base
  # Search
  include PgSearch
  pg_search_scope :search_pg,
                  against: [:id, :email],
                  using: { tsearch: { prefix: true } }
end
