# frozen_string_literal: true
require_relative '../test_helper'
class CheckWebsitesWorkerTest < ActiveSupport::TestCase # to have fixtures
  let(:spawner_worker) { CheckWebsitesWorker.new }

  it 'should correctly spawn single workers' do
    website = FactoryGirl.create :website, :own
    offer = FactoryGirl.create :offer, :approved
    offer.section =
      Section.find_by(identifier: 'refugees') ||
      FactoryGirl.create(
        :section, identifier: 'refugees', name: 'Refugees'
      )
    # remove faked random websites to ensure single invocation of perform_async
    Website.find_each do |faked_website|
      faked_website.offers = []
      faked_website.organizations = []
    end
    website.offers << offer
    CheckSingleWebsiteWorker.expects(:perform_async).with(website.id).once
    spawner_worker.perform
  end

  it 'should not spawn for ignored_by_crawler-boolean' do
    website = FactoryGirl.create :website, :own, ignored_by_crawler: true
    offer = FactoryGirl.create :offer, :approved
    offer.section =
      Section.find_by(identifier: 'refugees') ||
      FactoryGirl.create(
        :section, identifier: 'refugees', name: 'Refugees'
      )
    # remove faked random websites to ensure single invocation of perform_async
    Website.find_each do |faked_website|
      faked_website.offers = []
      faked_website.organizations = []
    end
    website.offers << offer
    # website is ignored_by_crawler => does not spawn worker
    CheckSingleWebsiteWorker.expects(:perform_async).with(website.id).never
    spawner_worker.perform
  end
end
