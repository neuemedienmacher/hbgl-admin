# frozen_string_literal: true
# require_relative '../test_helper'
#
# class CheckWebsitesWorkerTest < ActiveSupport::TestCase # to have fixtures
#   let(:spawner_worker) { CheckWebsitesWorker.new }
#   let(:single_worker) { CheckSingleWebsiteWorker.new }
#
#   it 'should create asana task, expire and index offer with 404 website' do
#     website = FactoryGirl.create :website, :own
#     offer = FactoryGirl.create :offer, :approved
#     website.offers << offer
#     Offer.any_instance.expects(:index!)
#     AsanaCommunicator.any_instance.expects(:create_website_unreachable_task_offer)
#     WebMock.stub_request(:get, 'www.example.com')
#       .to_return(status: 404, body: '', headers: {}) # 404 stub
#     single_worker.perform website.id
#     offer.reload.must_be :expired?
#   end
#
#   it 'should create asana task, expire and index offer with unreachable '\
#      'website' do
#     website = FactoryGirl.create :website, :own
#     offer = FactoryGirl.create :offer, :approved
#     website.offers << offer
#     Offer.any_instance.expects(:index!)
#     AsanaCommunicator.any_instance.expects(:create_website_unreachable_task_offer)
#     WebMock.stub_request(:get, 'www.example.com').to_timeout
#     single_worker.perform website.id
#     offer.reload.must_be :expired?
#   end
#
#   it 'should not do anything with a valid website' do
#     website = FactoryGirl.create :website, :own
#     offer = FactoryGirl.create :offer, :approved
#     website.offers << offer
#     Offer.any_instance.expects(:index!).never
#     AsanaCommunicator.any_instance.expects(:create_website_unreachable_task_offer).never
#     WebMock.stub_request(:get, 'www.example.com') # stub request to return success
#     single_worker.perform website.id
#     offer.reload.must_be :approved?
#   end
#
#   it 'should create asana task for orga with 404 website' do
#     website = FactoryGirl.create :website, :own
#     orga = FactoryGirl.create :organization, :approved, name: 'bazfuz'
#     website.organizations << orga
#     AsanaCommunicator.any_instance.expects(:create_website_unreachable_task_offer).never
#     AsanaCommunicator.any_instance.expects(:create_website_unreachable_task_orgas)
#     WebMock.stub_request(:get, 'www.example.com')
#       .to_return(status: 404, body: '', headers: {}) # 404 stub
#     single_worker.perform website.id
#   end
#
#   it 'should correctly spawn single workers' do
#     website = FactoryGirl.create :website, :own
#     orga = FactoryGirl.create :organization, :approved, name: 'bazfuz'
#     # remove faked random websites to ensure single invocation of perform_async
#     orga.websites.each do |faked_website|
#       faked_website.offers = []
#       faked_website.organizations = []
#     end
#     website.organizations << orga
#     CheckSingleWebsiteWorker.expects(:perform_async)
#     spawner_worker.perform
#   end
# end
