require_relative '../test_helper'

class UninformedEmailsMailingsWorkerTest < ActiveSupport::TestCase
  # extend ActiveSupport::TestCase to get fixtures
  let(:worker) { UninformedEmailsMailingsWorker.new }

  it 'calls #inform! on uninformed emails that have approved offers' do
    FactoryGirl.create :email, :uninformed, :with_approved_offer
    Email.any_instance.expects(:inform_offers!).once
    worker.perform
  end

  it 'doesnt call #inform! on uninformed emails without approved offers' do
    FactoryGirl.create :email, :uninformed, :with_unapproved_offer
    Email.any_instance.expects(:inform_offers!).never
    worker.perform
  end

  it 'doesnt call #inform! on informed emails that have approved offers' do
    FactoryGirl.create :email, :informed, :with_approved_offer
    Email.any_instance.expects(:inform_offers!).never
    worker.perform
  end

  it 'doesnt call #inform_orga! without informable organization' do
    email = FactoryGirl.create :email, :uninformed, :with_approved_offer
    email.organizations.update_all mailings_enabled: false
    email.contact_people.update_all position: 'superior'
    Email.any_instance.expects(:inform_orga!).never
    worker.perform
  end

  it 'doesnt call #inform_orga! for superior contact with informable orga'\
     ' because offer_mails have a higher priority' do
    email = FactoryGirl.create :email, :uninformed, :with_approved_offer
    email.organizations.update_all mailings_enabled: true, aasm_state: 'approved'
    email.contact_people.update_all position: 'superior'
    Email.any_instance.expects(:inform_orga!).never
    worker.perform
  end

  it 'call #inform_orga! for superior contact with informable orga if no'\
     ' offer_mails are sent before' do
    # Email does not have approved offers..
    email = FactoryGirl.create :email, :uninformed, :with_unapproved_offer
    email.organizations.update_all mailings_enabled: true, aasm_state: 'approved'
    email.contact_people.update_all position: 'superior'
    # .. but one orga has an approved offer
    email.organizations.first.offers << FactoryGirl.create(:offer, :approved)
    Email.any_instance.expects(:inform_orga!).once
    worker.perform
  end

  it 'doesnt calls #inform! on uninformed emails with approved offers but no'\
     ' mailings_enabled organization' do
    email = FactoryGirl.create :email, :uninformed, :with_approved_offer
    email.organizations.update_all mailings_enabled: false
    Email.any_instance.expects(:inform_offers!).never
    worker.perform
  end
end
