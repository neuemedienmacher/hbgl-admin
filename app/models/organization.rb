# frozen_string_literal: true
# Monkeypatch clarat_base Organization
require ClaratBase::Engine.root.join('app', 'models', 'organization')

class Organization < ActiveRecord::Base
  # Admin specific methods

  # State Machine
  aasm do
    event :mark_as_done, success: :apply_mailings_logic! do
      transitions from: :approved, to: :all_done
    end
  end

  # Customize duplication.
  def partial_dup
    self.dup.tap do |orga|
      orga.name = nil
      orga.founded = nil
      orga.aasm_state = 'initialized'
    end
  end

  # TODO: 'Big Orga' definition
  def big_orga_or_big_player?
    false || mailings == 'big_player'
  end

  def editable?
    %(initialized approved all_done approval_process checkup_process).
      include?(aasm_state)
  end

  private

  # sets mailings='enabled' but only if it's not a big orga or a big player
  # and only if mailings are 'disabled' (default) and not forced_disabled.
  def apply_mailings_logic!
    if big_orga_or_big_player?
      AsanaCommunicator.new.create_big_orga_is_done_task
    else
      self.mailings = 'enabled' if self.mailings == 'disabled'
    end
  end
end
