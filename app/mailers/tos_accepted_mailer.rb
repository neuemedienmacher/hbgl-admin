# frozen_string_literal: true
class TosAcceptedMailer < ActionMailer::Base

  # 'Storing' ToS-Acceptance by sending an additional internal mail
  def store_tos email
    @mail = email.address
    @date = Time.now.strftime("%d.%m.%Y")

    send_tos_accepted_mail email, email.offers
  end

  private

  def send_tos_accepted_mail email, offers
    email.create_tos_accepted_mailings offers
    mail subject: 'Einwilligung zur Datennutzung',
         from: email.address,
         to: 'dsgvo@handbookgermany.de'
  end
end
