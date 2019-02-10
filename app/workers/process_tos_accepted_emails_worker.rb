# frozen_string_literal: true
class ProcessTosAcceptedEmailsWorker
  include Sidekiq::Worker

  sidekiq_options queue: :heavy_load

  def perform
    Email.where(tos: 'accepted').map do |mail|
      # Skip if there is already at least one tos-accepted OfferMailing for mail
      next if OfferMailing.where(mailing_type: 'tos_accepted', email_id: mail.id).any?
      # Otherwise, trigger mailer which sends mails & creates OfferMailings
      TosAcceptedMailer.store_tos(mail).deliver_now
    end
  end
end
