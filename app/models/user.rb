# frozen_string_literal: true

# Monkeypatch clarat_base User
require ClaratBase::Engine.root.join('app', 'models', 'user')

class User < ApplicationRecord
  has_paper_trail

  devise :database_authenticatable, :validatable, :lockable, :timeoutable
  # , :registerable, :recoverable, :confirmable, :rememberable, :trackable

  # Methods

  def self.system_user
    find_by(name: 'System') || create!(
      name: 'System', password: SecureRandom.base64, email: 'dev@clarat.org',
      role: 'super'
    )
  end

  # Search
  include PgSearch
  pg_search_scope :search_pg,
                  against: %i[id name],
                  using: { tsearch: { prefix: true } }
end
