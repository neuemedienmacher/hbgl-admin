# frozen_string_literal: true
require_relative '../test_helper'

class SubscribedEmailsMailingsSpawnerWorkerTest < ActiveSupport::TestCase
  # extend ActiveSupport::TestCase to get fixtures
  let(:worker) { SubscribedEmailsMailingsSpawnerWorker.new }

  it 'sends mailing to subscribed emails that have approved offers' do
    email = FactoryGirl.create :email, :subscribed, :with_approved_offer
    SubscribedEmailMailingWorker.expects(:perform_async).with(email.id)
    worker.perform
  end

  it 'sends mailing to subscribed emails that have approved offers' do
    email = FactoryGirl.create :email, :subscribed, :with_approved_offer
    email.offers.update_all aasm_state: 'expired'
    SubscribedEmailMailingWorker.expects(:perform_async).with(email.id)
    worker.perform
  end

  it 'wont send mailing to subscribed emails that have approved offers but the'\
     ' organization is no longer all_done' do
    email = FactoryGirl.create :email, :subscribed, :with_approved_offer
    # reset every organization to 'approved' state instead of 'all_done'
    email.offers.map do |o|
      o.contact_people.map do |c|
        c.organization.update_columns aasm_state: 'approved'
      end
    end
    SubscribedEmailMailingWorker.expects(:perform_async).never
    worker.perform
  end

  it 'wont send mailing to subscribed emails that have expired offers but the'\
     ' organization is no longer all_done' do
    email = FactoryGirl.create :email, :subscribed, :with_approved_offer
    email.offers.update_all aasm_state: 'expired'
    # reset every organization to 'approved' state instead of 'all_done'
    email.offers.map do |o|
      o.contact_people.map do |c|
        c.organization.update_columns aasm_state: 'approved'
      end
    end
    SubscribedEmailMailingWorker.expects(:perform_async).never
    worker.perform
  end

  it 'wont send mailing to subscribed emails without approved offers' do
    FactoryGirl.create :email, :subscribed, :with_unapproved_offer
    SubscribedEmailMailingWorker.expects(:perform_async).never
    worker.perform
  end

  it 'wont send mailing to unsubscribed emails that have approved offers' do
    FactoryGirl.create :email, :unsubscribed, :with_approved_offer
    SubscribedEmailMailingWorker.expects(:perform_async).never
    worker.perform
  end

  it 'wont send mailing to unsubscribed emails that have expired offers' do
    email = FactoryGirl.create :email, :unsubscribed, :with_approved_offer
    email.offers.update_all aasm_state: 'expired'
    SubscribedEmailMailingWorker.expects(:perform_async).never
    worker.perform
  end

  it 'wont send mailing to uninformed emails that have approved offers' do
    FactoryGirl.create :email, :uninformed, :with_approved_offer
    SubscribedEmailMailingWorker.expects(:perform_async).never
    worker.perform
  end

  it 'wont send mailing to uninformed emails that have expired offers' do
    email = FactoryGirl.create :email, :uninformed, :with_approved_offer
    email.offers.update_all aasm_state: 'expired'
    SubscribedEmailMailingWorker.expects(:perform_async).never
    worker.perform
  end

  it 'wont send mailing to uninformed emails that have approved offers' do
    FactoryGirl.create :email, :uninformed, :with_approved_offer
    SubscribedEmailMailingWorker.expects(:perform_async).never
    worker.perform
  end

  it 'wont send mailing to uninformed emails that have expired offers' do
    email = FactoryGirl.create :email, :uninformed, :with_approved_offer
    email.offers.update_all aasm_state: 'expired'
    SubscribedEmailMailingWorker.expects(:perform_async).never
    worker.perform
  end

  it 'wont send mailing to informed emails that have approved offers' do
    FactoryGirl.create :email, :informed, :with_approved_offer
    SubscribedEmailMailingWorker.expects(:perform_async).never
    worker.perform
  end

  it 'wont send mailing to informed emails that have expired offers' do
    email = FactoryGirl.create :email, :informed, :with_approved_offer
    email.offers.update_all aasm_state: 'expired'
    SubscribedEmailMailingWorker.expects(:perform_async).never
    worker.perform
  end

  it 'wont send mailing to subscribed emails with approved offers but no'\
     ' mailings=enabled organization' do
    email = FactoryGirl.create :email, :subscribed, :with_approved_offer
    email.organizations.update_all mailings: 'force_disabled'
    SubscribedEmailMailingWorker.expects(:perform_async).never
    worker.perform
  end

  it 'wont send mailing to subscribed emails with expired offers but no'\
     ' mailings=enabled organization' do
    email = FactoryGirl.create :email, :subscribed, :with_approved_offer
    email.offers.update_all aasm_state: 'expired'
    email.organizations.update_all mailings: 'force_disabled'
    SubscribedEmailMailingWorker.expects(:perform_async).never
    worker.perform
  end
end
