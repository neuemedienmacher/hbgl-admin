# frozen_string_literal: true
require_relative '../test_helper'

class UninformedEmailsMailingsSpawnerWorkerTest < ActiveSupport::TestCase
  # extend ActiveSupport::TestCase to get fixtures
  let(:worker) { UninformedEmailsMailingsSpawnerWorker.new }

  it 'spawns on uninformed emails that have approved offers' do
    email = FactoryGirl.create :email, :uninformed, :with_approved_offer
    UninformedEmailMailingWorker.expects(:perform_async).with(email.id)
    worker.perform
  end

  it 'doesnt spawn on uninformed emails without approved offers' do
    FactoryGirl.create :email, :uninformed, :with_unapproved_offer
    UninformedEmailMailingWorker.expects(:perform_async).never
    worker.perform
  end

  it 'doesnt spawn on informed emails that have approved offers' do
    FactoryGirl.create :email, :informed, :with_approved_offer
    UninformedEmailMailingWorker.expects(:perform_async).never
    worker.perform
  end

  it 'doesnt spawn without informable organization' do
    email = FactoryGirl.create :email, :uninformed, :with_approved_offer
    email.organizations.update_all mailings: 'force_disabled'
    email.contact_people.update_all position: 'superior'
    UninformedEmailMailingWorker.expects(:perform_async).never
    worker.perform
  end

  # it 'doesnt spawn for superior contact with informable orga'\
  #    ' because offer_mails have a higher priority' do
  #   email = FactoryGirl.create :email, :uninformed, :with_approved_offer
  #   email.organizations.update_all mailings: 'enabled', aasm_state: 'approved'
  #   email.contact_people.update_all position: 'superior'
  #   UninformedEmailMailingWorker.expects(:perform_async).
  #   worker.perform
  # end

  it 'spawns for superior contact with informable orga if no'\
     ' offer_mails are sent before' do
    # Email does not have approved offers..
    email = FactoryGirl.create :email, :uninformed, :with_unapproved_offer
    email.organizations.update_all mailings: 'enabled', aasm_state: 'all_done'
    email.contact_people.update_all position: 'superior'
    # .. but one orga has an approved offer
    email.organizations.first.offers << FactoryGirl.create(:offer, :approved)
    UninformedEmailMailingWorker.expects(:perform_async).with(email.id)
    worker.perform
  end

  it 'doesnt spawn on uninformed emails with approved offers but no'\
     ' mailings=enabled organization' do
    email = FactoryGirl.create :email, :uninformed, :with_approved_offer
    email.organizations.update_all mailings: 'force_disabled'
    UninformedEmailMailingWorker.expects(:perform_async).never
    worker.perform
  end
end
