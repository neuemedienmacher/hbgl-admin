# frozen_string_literal: true

class ProcessTosDeclinedEmailsWorker
  include Sidekiq::Worker

  sidekiq_options queue: :heavy_load

  def perform
    offer_ids_to_deactivate = []
    Email.transaction do
      ContactPerson.transaction do
        deletable_emails = Email.where(tos: 'declined')
        deletable_contact_ids = []

        deletable_emails.pluck(:id).map do |mail_id|
          email = Email.find mail_id
          deletable_contact_ids << email.contact_people.pluck(:id)
          # NOTE this is okay, because we know that there is at least one email
          offer_ids_to_deactivate <<
            email.offers.visible_in_frontend
                 .select{ |o| o.emails.pluck(:tos).uniq == ['declined'] }
                 .pluck(:id)
          email.destroy!
        end

        # NOTE ensure that the contact_people for the ids still exist
        still_existing_contact_ids =
          ContactPerson.where(id: deletable_contact_ids.flatten.uniq).pluck(:id)
        still_existing_contact_ids.map do |contact_id|
          # NOTE we choose to NOT destroy the entries & overwrite the
          # GDPR-relevant fields instead. We have to iterate instead of simply
          # using update_all because of the dynamic label adjustment
          cp = ContactPerson.find(contact_id)
          cp.update_columns(
            first_name: nil,
            last_name: nil,
            area_code_1: nil,
            local_number_1: nil,
            area_code_2: nil,
            local_number_2: nil,
            fax_area_code: nil,
            fax_number: nil,
            gender: nil,
            label: (!cp.label.nil? ? cp.label : '') + ' [TOS DECLINED]'
          )
        end
      end
    end

    Offer.transaction do
      offer_ids_to_deactivate.flatten.uniq.map do |offer_id|
        DeactivateOfferWorker.perform_async offer_id
      end
    end
  end
end
