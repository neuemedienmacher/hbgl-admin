# frozen_string_literal: true
# Monkeypatch clarat_base Organization
require ClaratBase::Engine.root.join('app', 'models', 'organization')

class Organization < ActiveRecord::Base
  # Admin specific methods

  # Customize duplication.
  def partial_dup
    self.dup.tap do |orga|
      orga.name = nil
      orga.founded = nil
      orga.aasm_state = 'initialized'
    end
  end
end
