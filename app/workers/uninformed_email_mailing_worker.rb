# frozen_string_literal: true

# Trigger an emails inform event to send them a mailing.
class UninformedEmailMailingWorker
  include Sidekiq::Worker
  sidekiq_options retry: 0

  def perform email_id
    email = Email.find(email_id)
    email.inform!
  end
end
