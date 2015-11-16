require_relative '../test_helper'

class CheckWebsitesWorkerTest < ActiveSupport::TestCase # to have fixtures
  let(:worker) { CheckWebsitesWorker.new }

  it 'should create asana task, expire and index offer with 404 website' do
    website = FactoryGirl.create :website, :own
    offer = FactoryGirl.create :offer, :approved
    offer.websites = [] # remove faked websites
    website.offers << offer
    Offer.any_instance.expects(:index!)
    AsanaCommunicator.any_instance.expects(:create_expire_task)
    stub_request(:get, 'www.example.com')
      .to_return(status: 404, body: '', headers: {}) # 404 stub
    worker.perform
    offer.reload.must_be :expired?
  end

  it 'should create asana task, expire and index offer with unreachable'\
     'website' do
    website = FactoryGirl.create :website, :own
    offer = FactoryGirl.create :offer, :approved
    offer.websites = [] # remove faked websites
    website.offers << offer
    Offer.any_instance.expects(:index!)
    AsanaCommunicator.any_instance.expects(:create_expire_task)
    stub_request(:get, 'www.example.com').to_timeout
    worker.perform
    offer.reload.must_be :expired?
  end

  it 'should not do anything with a valid website' do
    website = FactoryGirl.create :website, :own
    offer = FactoryGirl.create :offer, :approved
    offer.websites = [] # remove faked websites
    website.offers << offer
    Offer.any_instance.expects(:index!).never
    AsanaCommunicator.any_instance.expects(:create_expire_task).never
    stub_request(:get, 'www.example.com') # stub request to return success
    worker.perform
    offer.reload.must_be :approved?
  end
end
