# Worker to check bi-weekly, whether there are emails that
# - have not yet been informed
# - have approved offers
# - belongs to at least one organization that has `mailings_enabled: true`
# and trigger their inform event to send them a mailing each.
class UninformedEmailsMailingsWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { weekly(2).day(:monday).hour_of_day(20).minute_of_hour(30) }

  def perform
    # return # TODO: remove to reenable mailings (also rubocop, tests, cov filter)
    Offer.transaction do
      Email.transaction do
        # first send offer mailings...
        informable_offer_emails.find_each(&:inform_offers!)
        # ... then orga mailings (to avoid both for one email)
        informable_orga_emails.map(&:inform_orga!)
      end
    end
  end

  private

  def informable_offer_emails
    Email.where(aasm_state: 'uninformed').uniq
      .joins(:offers).where('offers.aasm_state = ?', 'approved')
      .joins(:organizations).where('organizations.mailings_enabled = ?', true)
  end

  def informable_orga_emails
    Email.where(aasm_state: 'uninformed').select do |mail|
      mail.contact_people.select do |contact|
        !contact.position.nil? && informable_orga?(contact.organization)
      end.any?
    end
  end

  def informable_orga? orga
    orga.aasm_state == 'approved' && orga.mailings_enabled &&
      orga.offers.approved.count > 0 && orga.locations.count < 10
  end
end
