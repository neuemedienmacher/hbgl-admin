# frozen_string_literal: true

require_relative '../test_helper'

class CheckForNewContactsWorkerTest < ActiveSupport::TestCase
  let(:worker) { CheckForNewContactsWorker.new }

  it 'should deliver internal mail for new contact and toggle bool flag' do
    new_contact = Contact.create! name: 'Jim Panse', message: 'TestMessage',
                                  email: 'test@example.com', url: 'www.example.com'

    ContactMailer.expect_chain(:admin_notification, :deliver_now)
    worker.perform
    new_contact.reload.internal_mail.must_equal true
  end
end
