# frozen_string_literal: true

require_relative '../test_helper'
# to have fixtures
class CheckUnreachableOffersWorkerTest < ActiveSupport::TestCase
  let(:worker) { CheckUnreachableOffersWorker.new }

  it 'should re-activate deactivated valid offer if website is reachable' do
    website = FactoryBot.create :website, :own, unreachable_count: 0
    offer = FactoryBot.create :offer, :approved
    offer.update_columns aasm_state: 'website_unreachable'
    website.offers << offer
    Offer.any_instance.expects(:index!).once
    worker.perform
    offer.reload.must_be :approved?
  end

  it 'should NOT re-activate deactivated'\
     'invalid offer with reachable website' do
    website = FactoryBot.create :website, :own, unreachable_count: 0
    invalid_offer = FactoryBot.create :offer, :approved
    invalid_offer.update_columns(
      aasm_state: 'website_unreachable',
      encounter: nil
    )
    website.offers << invalid_offer
    Offer.any_instance.expects(:index!).never
    worker.perform
    invalid_offer.reload.must_be :website_unreachable?
  end

  it 'should NOT re-activate valid offer if website is unreachable' do
    website = FactoryBot.create :website, :own,
                                unreachable_count: 1, ignored_by_crawler: false
    offer = FactoryBot.create :offer, :approved
    offer.update_columns aasm_state: 'website_unreachable'
    website.offers << offer
    Offer.any_instance.expects(:index!).never
    worker.perform
    offer.reload.must_be :website_unreachable?
  end

  it 'should re-activate valid offer if website should be ignored by crawler' do
    website = FactoryBot.create :website, :own,
                                unreachable_count: 1, ignored_by_crawler: true
    offer = FactoryBot.create :offer, :approved
    offer.update_columns aasm_state: 'website_unreachable'
    website.offers << offer
    Offer.any_instance.expects(:index!).once
    worker.perform
    offer.reload.wont_equal :website_unreachable?
  end

  it 'should NOT re-activate valid offer if it has no website' do
    offer = FactoryBot.create :offer, :approved, website_count: 0
    offer.update_columns aasm_state: 'website_unreachable'
    worker.perform
    offer.reload.must_be :website_unreachable?
  end
end
