# frozen_string_literal: true

class CheckForNewContactsWorker
  include Sidekiq::Worker

  def perform
    new_contacts = Contact.where(internal_mail: false)
    new_contacts.each do |new_contact|
      mail = ContactMailer.admin_notification(new_contact.id)

      next unless mail
      # send email
      mail.deliver_now
      # set internal_mail to true
      new_contact.update_columns internal_mail: true
    end
  end
end
