# frozen_string_literal: true
require_relative '../test_helper'
# Be quite, rubocop - this is a test class!
# rubocop:disable Metrics/ClassLength
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
        name: 'foobar,bazfuz - 9999-01-01 - fam - basicOfferName',
        notes: 'Expired: http://claradmin.herokuapp.com/admin/offer/1/edit'
      )

      offer = offers(:basic)
      orga = FactoryGirl.create :organization, :approved, name: 'bazfuz'
      offer.organizations << orga

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
        name: '[Offer website unreachable] family | Version: 1 | foobar,bazfuz | basicOfferName',
        notes: 'Deactivated: http://claradmin.herokuapp.com/admin/offer/1/edit'\
               " | Unreachable website: #{website.url}"
      )

      offer = offers(:basic)
      website.offers << offer
      orga = FactoryGirl.create :organization, :approved, name: 'bazfuz'
      offer.organizations << orga

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
              'foobar,bazfuz | basicOfferName',
        notes: 'http://claradmin.herokuapp.com/admin/offer/1/edit'
      )

      offer = offers(:basic)
      offer.starts_at = offer.expires_at - 1.year
      orga = FactoryGirl.create :organization, :approved, name: 'bazfuz'
      offer.organizations << orga

      object.create_seasonal_offer_ready_for_checkup_task offer
    end

    it 'should end up in an HTTP request' do
      Net::HTTP.any_instance.expects :request
      offer = offers(:basic)
      offer.starts_at = offer.expires_at - 1.year
      object.create_seasonal_offer_ready_for_checkup_task offer
    end
  end

  describe '#create_big_orga_is_done_task' do
    it 'should call #post_to_api with apropriate data' do
      website = FactoryGirl.create :website, :own
      positon_contact = FactoryGirl.create :contact_person, position: 'superior'
      orga = FactoryGirl.create :organization, :approved, name: 'bazfuz'
      website.organizations << orga
      orga.contact_people << positon_contact
      offer = offers(:basic)
      offer.organizations << orga

      object.expects(:post_to_api).with(
        '/api/1.0/tasks',
        projects: %w(85803884880432), workspace: '41140436022602',
        name: 'family | bazfuz',
        notes: "http://claradmin.herokuapp.com/admin/organization/#{orga.id}/"\
               'edit | Position-Kontakt: http://claradmin.herokuapp.com/admin/'\
               "contact_person/#{positon_contact.id}/edit | Website: http://"\
               "claradmin.herokuapp.com/admin/website/#{orga.homepage.id}/edit"
      )

      object.create_big_orga_is_done_task orga
    end

    it 'should end up in an HTTP request' do
      Net::HTTP.any_instance.expects :request
      offer = offers(:basic)
      offer.starts_at = offer.expires_at - 1.year
      object.create_seasonal_offer_ready_for_checkup_task offer
    end
  end
end
# rubocop:enable Metrics/ClassLength
