# frozen_string_literal: true

class TosMailer < ActionMailer::Base

  # Informing email addresses about the ToS, asking for approval or denial
  # @attr email Email object this is sent to
  def inform_tos email, date = (Time.now + 2.weeks)
    # Loads of variables in preparation for view models (email view)
    # @offers = email.offers.visible_in_frontend
    @offers = email.offers
    @tos_href = "https://local.handbookgermany.de/emails/#{email.token}/angebote"
    @reply_date = date.strftime("%d.%m.%Y")

    send_tos_email email, @offers
  end

  private

  def send_tos_email email, offers
    email.create_tos_mailings offers
    mail subject: 'Ihre Aufnahme in Deutschlands größte Datenbank für soziale Organisationen',
         from: 'Sabine Roßmann <localsearch@handbookgermany.de>',
         to: email.address
  end
end
