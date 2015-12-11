# Monkeypatch clarat_base CotactPerson
require ClaratBase::Engine.root.join('app', 'models', 'contact_person')

class ContactPerson < ActiveRecord::Base
  # Admin specific methods

  # Customize duplication.
  def partial_dup
    self.dup.tap do |contact_person|
      contact_person.offers = self.offers
    end
  end
end
