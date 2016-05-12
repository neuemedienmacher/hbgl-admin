# frozen_string_literal: true
require_relative '../test_helper'

class AsanaCommunicatorTest < ActiveSupport::TestCase # to have fixtures
  let(:object) { AsanaCommunicator.new }

  before do
    Net::HTTP.any_instance.stubs(:request)
  end

  describe '#create_expire_task' do
    it 'should call #post_to_api with apropriate data' do
      object.expects(:post_to_api).with(
        '/tasks',
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
        '/tasks',
        projects: %w(44856824806357), workspace: '41140436022602',
        name: '[URL unreachable]foobar,bazfuz-9999-01-01-basicOfferName',
        notes: 'Expired: http://claradmin.herokuapp.com/admin/offer/1/edit'\
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
        '/tasks',
        projects: %w(44856824806357), workspace: '41140436022602',
        name: '[URL unreachable]bazfuz',
        notes: "Unreachable website: #{website.url}"
      )

      orga = FactoryGirl.create :organization, :approved, name: 'bazfuz'
      website.organizations << orga

      object.create_website_unreachable_task_orgas website
    end
  end
end
