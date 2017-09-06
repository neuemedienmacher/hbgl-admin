# frozen_string_literal: true
# Monkeypatch clarat_base update_request
require ClaratBase::Engine.root.join('app', 'models', 'update_request')
class UpdateRequest < ActiveRecord::Base
  # Search
  include PgSearch
  pg_search_scope :search_pg,
                  against: [:id, :email, :search_location],
                  using: { tsearch: { prefix: true } }
end
