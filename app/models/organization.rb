# frozen_string_literal: true
# Monkeypatch clarat_base Organization
require ClaratBase::Engine.root.join('app', 'models', 'organization')

class Organization < ActiveRecord::Base
  # Admin specific methods

  # Modules
  include StateMachine

  # Concerns
  include Translations

  # Search
  include PgSearch
  # Search
  pg_search_scope :search_everything,
                  against: [
                    :id, :offers_count, :name, :aasm_state, :locations_count
                  ],
                  using: { tsearch: { prefix: true } }

  # Customize duplication.
  def partial_dup
    self.dup.tap do |orga|
      orga.name = nil
      orga.founded = nil
      orga.aasm_state = 'initialized'
      orga.mailings = 'disabled'
      orga.umbrella_filters = umbrella_filters
    end
  end

  private

  # sets mailings but only if it's mailings='disabled' (other options are
  # chosen explicitly and stay the same)
  def enable_mailings!
    self.update_columns mailings: 'enabled' unless mailings == 'force_disabled'
  end
end
