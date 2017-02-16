# frozen_string_literal: true
# Monkeypatch clarat_base Organization
require ClaratBase::Engine.root.join('app', 'models', 'organization')

class Organization < ActiveRecord::Base
  # Search Terms for significant/big_player organizations. Only one must match
  BIG_PLAYER_SEARCH_TERMS = %w(
    berlin münchen köln düsseldorf nrw nordrhein-westfalen bayern deutschland
    bund deutscher international arbeitsgemeinschaft verband verbund
  ).freeze
  # Admin specific methods

  # Concerns
  include Translations

  # State Machine
  aasm do
    event :mark_as_done, success: :apply_mailings_logic! do
      transitions from: :approved, to: :all_done
    end
  end

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

  def big_player?
    locations.count >= 10 || (locations.count >= 2 &&
      offers.visible_in_frontend.where(encounter: 'personal').count >= 10 &&
      BIG_PLAYER_SEARCH_TERMS.map { |t| name.downcase.include?(t) }.any?)
  end

  private

  # sets mailings but only if it's mailings='disabled' (other options are
  # chosen explicitly and stay the same). big_player Orgas get the apropriate
  # option and an AsanaTask is created while other orgas get mailings=enabled
  def apply_mailings_logic!
    if self.mailings == 'disabled'
      if big_player?
        AsanaCommunicator.new.create_big_orga_is_done_task self
        self.update_columns mailings: 'big_player'
      else
        self.update_columns mailings: 'enabled'
      end
    end
  end
end
