# frozen_string_literal: true

require_relative '../test_helper'

class SubscribedEmailMailingWorkerTest < ActiveSupport::TestCase
  # extend ActiveSupport::TestCase to get fixtures
  let(:worker) { SubscribedEmailMailingWorker.new }

  it 'sends mailing to subscribed emails that have approved offers' do
    email = FactoryBot.create :email, :subscribed, :with_approved_offer
    OfferMailer.expect_chain(:newly_approved_offers, :deliver_now).once
    worker.perform email.id
  end

  it 'sends mailing to subscribed emails that have expired offers' do
    email = FactoryBot.create :email, :subscribed, :with_approved_offer
    email.offers.update_all aasm_state: 'expired'
    OfferMailer.expect_chain(:newly_approved_offers, :deliver_now).once
    worker.perform email.id
  end

  it 'wont send mailing to subscribed emails that have approved offers but'\
     ' that were already informed about those offers' do
    email = FactoryBot.create :email, :subscribed, :with_approved_offer
    email.create_offer_mailings email.offers.all, :inform
    OfferMailer.expects(:newly_approved_offers).never
    worker.perform email.id
  end

  it 'wont send mailing to subscribed emails that have expired offers but'\
     ' that were already informed about those offers' do
    email = FactoryBot.create :email, :subscribed, :with_approved_offer
    email.offers.update_all aasm_state: 'expired'
    email.create_offer_mailings email.offers.all, :inform
    OfferMailer.expects(:newly_approved_offers).never
    worker.perform email.id
  end

  it 'wont send mailing to subscribed emails without approved offers' do
    email = FactoryBot.create :email, :subscribed, :with_unapproved_offer
    OfferMailer.expects(:newly_approved_offers).never
    worker.perform email.id
  end
end
