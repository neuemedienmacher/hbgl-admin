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
        projects: %w(44856824806357), workspace: '41140436022602',
        name: 'foobar,bazfuz - 9999-01-01 - fam - basischAngebotName',
        notes: 'Expired: http://claradmin.herokuapp.com/admin/offer/1/edit'
      )

      offer = offers(:basic)
      division = FactoryGirl.create :division
      division.organization.update_columns name: 'bazfuz'
      offer.split_base.divisions << division

      object.create_expire_task offer
    end

    it 'should end up in an HTTP request' do
      Net::HTTP.any_instance.expects :request
      object.create_expire_task offers(:basic)
    end
  end

  describe '#create_website_unreachable_task_offer' do
    it 'should call #post_to_api with apropriate data and perform HTTP req' do
      website = FactoryGirl.create :website, :own
      object.expects(:post_to_api).with(
        '/api/1.0/tasks',
        projects: %w(147663824592112), workspace: '41140436022602',
        name: '[Offer website unreachable] family | Version: 1 | foobar,bazfuz | basischAngebotName',
        notes: 'Deactivated: http://claradmin.herokuapp.com/admin/offer/1/edit'\
               " | Unreachable website: #{website.url}"
      )

      offer = offers(:basic)
      website.offers << offer
      division = FactoryGirl.create :division
      division.organization.update_columns name: 'bazfuz'
      offer.split_base.divisions << division

      object.create_website_unreachable_task_offer website, offer
    end
  end

  describe '#create_website_unreachable_task_orgas' do
    it 'should call #post_to_api with apropriate data and perform HTTP req' do
      website = FactoryGirl.create :website, :own
      website.offers = []
      object.expects(:post_to_api).with(
        '/api/1.0/tasks',
        projects: %w(147663824592112), workspace: '41140436022602',
        name: '[Orga-website unreachable] bazfuz',
        notes: "Unreachable website: #{website.url}"
      )

      orga = FactoryGirl.create :organization, :approved, name: 'bazfuz'
      website.organizations << orga

      object.create_website_unreachable_task_orgas website
    end
  end

  describe '#create_seasonal_offer_ready_for_checkup_task' do
    it 'should call #post_to_api with apropriate data' do
      object.expects(:post_to_api).with(
        '/api/1.0/tasks',
        projects: %w(147663824592112), workspace: '41140436022602',
        name: 'WV | Saisonales Angebot | Start date: 9998-01-01 | '\
              'foobar,bazfuz | basischAngebotName',
        notes: 'http://claradmin.herokuapp.com/admin/offer/1/edit'
      )

      offer = offers(:basic)
      offer.starts_at = offer.expires_at - 1.year
      division = FactoryGirl.create :division
      division.organization.update_columns name: 'bazfuz'
      offer.split_base.divisions << division

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
