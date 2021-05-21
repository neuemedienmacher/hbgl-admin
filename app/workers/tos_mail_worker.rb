# frozen_string_literal: true

# Trigger an emails inform event to send them a mailing.
class TosMailWorker
  include Sidekiq::Worker
  sidekiq_options retry: 0

  def perform email_id
    email = Email.find(email_id)
    if email.tos == 'uninformed'
      TosMailer.inform_tos(email).deliver_now
      email.update_columns tos: 'pending'
    end
  end
end
