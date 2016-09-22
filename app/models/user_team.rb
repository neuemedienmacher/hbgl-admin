# frozen_string_literal: true
# Monkeypatch clarat_base UserTeam
require ClaratBase::Engine.root.join('app', 'models', 'user_team')

class UserTeam < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search_everything,
                  against: [
                    :id, :name
                  ],
                  using: { tsearch: { prefix: true } }
end
