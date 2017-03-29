# frozen_string_literal: true
class ContactMailer < ActionMailer::Base
  def admin_notification contact_id
    @contact = Contact.find(contact_id)
    sender = @contact.email? ? @contact.email : 'fehler@clarat.org'
    mail subject: 'Neue Nachricht vom clarat-Kontaktformular',
         to:      Rails.application.secrets.emails['admin'],
         reply_to: sender,
         from:    Rails.application.secrets.emails['admin']
  end
end
