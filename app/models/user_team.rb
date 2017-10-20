# frozen_string_literal: true

# Monkeypatch clarat_base UserTeam
require ClaratBase::Engine.root.join('app', 'models', 'user_team')

class UserTeam < ApplicationRecord
  include PgSearch
  pg_search_scope :search_pg,
                  against: %i[
                    id name
                  ],
                  using: { tsearch: { prefix: true } }
end
