# frozen_string_literal: true
# Monkeypatch clarat_base Email
require ClaratBase::Engine.root.join('app', 'models', 'email')

class Email < ActiveRecord::Base
  # Associations
  has_many :offer_mailings, inverse_of: :email
  has_many :known_offers, source: :offer, through: :offer_mailings,
                          inverse_of: :informed_emails

  # State Machine
  aasm do
    event :inform_offers, guard: :informable_offers? do
      # First check if email needs to be blocked
      transitions from: :uninformed, to: :blocked, guard: :should_be_blocked?
      # Else send email if there are approved offers
      transitions from: :uninformed, to: :informed,
                  after: :send_offer_information
    end

    event :inform_orga, guard: :belongs_to_unique_orga_with_orga_contact? do
      # First check if email needs to be blocked
      transitions from: :uninformed, to: :blocked, guard: :should_be_blocked?
      # Else send email if there are approved offers
      transitions from: :uninformed, to: :informed,
                  after: :send_orga_information
    end
  end

  # Methods
  def not_yet_but_soon_known_offers
    offers.approved.by_mailings_enabled_organization.all - known_offers.all
  end

  def create_offer_mailings offers, mailing_type
    offers.each do |offer|
      OfferMailing.create! offer_id: offer.id, email_id: id,
                           mailing_type: mailing_type
    end
  end

  def send_offer_information
    regenerate_security_code
    OfferMailer.inform(self).deliver_now
  end

  def send_orga_information
    regenerate_security_code
    OrgaMailer.inform(self).deliver_now
  end

  # required for both offer and orga mailer
  def vague_contact_title?
    contact_person = contact_people.first
    contact_people.count > 1 || !contact_person.gender ||
      (!contact_person.last_name? && !contact_person.first_name?)
  end

  private

  # email belongs to at least one orga-contact and has a distinct orga
  def belongs_to_unique_orga_with_orga_contact?
    contact_people.where.not(position: nil).any? &&
      contact_people.map(&:organization).uniq.count == 1
  end

  def informable_offers?
    contact_people.joins(:offers)
                  .where('offers.aasm_state = ?', 'approved').any? &&
      organizations.where(mailings_enabled: true).any?
  end
end
