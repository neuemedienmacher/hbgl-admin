# frozen_string_literal: true
require_relative '../test_helper'
class CheckUnreachableOffersWorkerTest < ActiveSupport::TestCase # to have fixtures
  let(:worker) { CheckUnreachableOffersWorker.new }

  it 'should re-activate deactivated valid offer if website is reachable' do
    website = FactoryGirl.create :website, :own, unreachable_count: 0
    offer = FactoryGirl.create :offer, :approved
    offer.update_columns aasm_state: 'website_unreachable'
    website.offers << offer
    Offer.any_instance.expects(:index!).once
    worker.perform
    offer.reload.must_be :approved?
  end

  it 'should NOT re-activate deactivated invalid offer with reachable website' do
    website = FactoryGirl.create :website, :own, unreachable_count: 0
    invalid_offer = FactoryGirl.create :offer, :approved
    invalid_offer.update_columns(
      aasm_state: 'website_unreachable',
      starts_at: Time.zone.now,
      expires_at: Time.zone.now - 1.day
    )
    website.offers << invalid_offer
    Offer.any_instance.expects(:index!).never
    worker.perform
    invalid_offer.reload.must_be :website_unreachable?
  end

  it 'should NOT re-activate valid offer if website is unreachable' do
    website = FactoryGirl.create :website, :own, unreachable_count: 1
    offer = FactoryGirl.create :offer, :approved
    offer.update_columns aasm_state: 'website_unreachable'
    website.offers << offer
    Offer.any_instance.expects(:index!).never
    worker.perform
    offer.reload.must_be :website_unreachable?
  end

  it 'should NOT re-activate valid offer if it has no website' do
    offer = FactoryGirl.create :offer, :approved, website_count: 0
    offer.update_columns aasm_state: 'website_unreachable'
    worker.perform
    offer.reload.must_be :website_unreachable?
  end
end
