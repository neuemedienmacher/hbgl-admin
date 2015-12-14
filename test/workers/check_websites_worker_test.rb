require_relative '../test_helper'

class CheckWebsitesWorkerTest < ActiveSupport::TestCase # to have fixtures
  let(:worker) { CheckSingleWebsiteWorker.new }

  it 'should create asana task, expire and index offer with 404 website' do
    website = FactoryGirl.create :website, :own
    offer = FactoryGirl.create :offer, :approved
    website.offers << offer
    Offer.any_instance.expects(:index!)
    AsanaCommunicator.any_instance.expects(:create_website_unreachable_task_offer)
    stub_request(:get, 'www.example.com')
      .to_return(status: 404, body: '', headers: {}) # 404 stub
    worker.perform website.id
    offer.reload.must_be :expired?
  end

  it 'should create asana task, expire and index offer with unreachable '\
     'website' do
    website = FactoryGirl.create :website, :own
    offer = FactoryGirl.create :offer, :approved
    website.offers << offer
    Offer.any_instance.expects(:index!)
    AsanaCommunicator.any_instance.expects(:create_website_unreachable_task_offer)
    stub_request(:get, 'www.example.com').to_timeout
    worker.perform website.id
    offer.reload.must_be :expired?
  end

  it 'should not do anything with a valid website' do
    website = FactoryGirl.create :website, :own
    offer = FactoryGirl.create :offer, :approved
    website.offers << offer
    Offer.any_instance.expects(:index!).never
    AsanaCommunicator.any_instance.expects(:create_website_unreachable_task_offer).never
    stub_request(:get, 'www.example.com') # stub request to return success
    worker.perform website.id
    offer.reload.must_be :approved?
  end

  it 'should create asana task for orga with 404 website' do
    website = FactoryGirl.create :website, :own
    orga = FactoryGirl.create :organization, :approved, name: 'bazfuz'
    website.organizations << orga
    AsanaCommunicator.any_instance.expects(:create_website_unreachable_task_offer).never
    AsanaCommunicator.any_instance.expects(:create_website_unreachable_task_orgas)
    stub_request(:get, 'www.example.com')
      .to_return(status: 404, body: '', headers: {}) # 404 stub
    worker.perform website.id
  end
end
