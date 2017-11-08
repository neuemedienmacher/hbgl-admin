# frozen_string_literal: true

require_relative '../test_helper'
# Be quite, rubocop - this is a test class!
class AsanaCommunicatorTest < ActiveSupport::TestCase # to have fixtures
  let(:object) { AsanaCommunicator.new }

  before do
    Net::HTTP.any_instance.stubs(:request)
  end

  describe '#create_expire_task' do
    it 'should call #post_to_api with apropriate data' do
      object.expects(:post_to_api).with(
        '/api/1.0/tasks',
        projects: %w[44856824806357], workspace: '41140436022602',
        name: 'foobar,bazfuz - 10000-01-01 01:00:00 +0100 - fam - basicOfferName',
        notes: 'Expired: http://claradmin.herokuapp.com/offers/1/edit'
      )

      offer = offers(:basic)
      division = FactoryGirl.create :division
      division.organization.update_columns name: 'bazfuz'
      offer.divisions << division

      object.create_expire_task offer
    end

    it 'should end up in an HTTP request' do
      Net::HTTP.any_instance.expects :request
      object.create_expire_task offers(:basic)
    end
  end

  describe '#create_seasonal_offer_ready_for_checkup_task' do
    it 'should call #post_to_api with apropriate data' do
      object.expects(:post_to_api).with(
        '/api/1.0/tasks',
        projects: %w[147663824592112], workspace: '41140436022602',
        name: 'WV | Saisonales Angebot | Start date: 9999-01-01 | '\
              'foobar,bazfuz | basicOfferName',
        notes: 'http://claradmin.herokuapp.com/offers/1/edit'
      )

      offer = offers(:basic)
      offer.starts_at = offer.expires_at - 1.year
      division = FactoryGirl.create :division
      division.organization.update_columns name: 'bazfuz'
      offer.divisions << division

      object.create_seasonal_offer_ready_for_checkup_task offer
    end

    it 'should end up in an HTTP request' do
      Net::HTTP.any_instance.expects :request
      offer = offers(:basic)
      offer.starts_at = offer.expires_at - 1.year
      object.create_seasonal_offer_ready_for_checkup_task offer
    end
  end
end
