# frozen_string_literal: true

require_relative '../test_helper'

class CheckSingleWebsiteWorkerTest < ActiveSupport::TestCase # to have fixtures
  let(:single_worker) { CheckSingleWebsiteWorker.new }

  it 'should create an assignment, expire and index offer with 404 website' do
    website = FactoryGirl.create :website, :own
    offer = FactoryGirl.create :offer, :approved
    website.offers << offer
    Offer.any_instance.expects(:index!)
    WebMock.stub_request(:head, 'www.example.com')
           .to_return(status: 404, body: '', headers: {}) # 404 stub
    WebMock.stub_request(:get, 'www.example.com')
           .to_return(status: 404, body: '', headers: {}) # 404 stub
    # first time: offer stays approved but unreachable is set to true
    single_worker.perform website.id
    offer.reload.must_be :approved?
    website.reload.unreachable_count.must_equal 1
    # second time: offer is expired and unreachable_count is incremented
    single_worker.perform website.id
    offer.reload.must_be :website_unreachable?
    website.reload.unreachable_count.must_equal 2
    Assignment.last.message.must_equal '[Offer-website unreachable] | '\
                                       "#{website.url}"
  end

  it 'should create an assignment, expire and index offer with timeout '\
     'website' do
    website = FactoryGirl.create :website, :own, unreachable_count: 1
    offer = FactoryGirl.create :offer, :approved
    website.offers << offer
    Offer.any_instance.expects(:index!)
    WebMock.stub_request(:head, 'www.example.com').to_timeout
    single_worker.perform website.id
    offer.reload.must_be :website_unreachable?
    website.reload.unreachable_count.must_equal 2
    Assignment.last.message.must_equal '[Offer-website unreachable] | '\
                                       "#{website.url}"
  end

  it 'should increment unreachable_count but not create an assignment for'\
     'the second time' do
    website = FactoryGirl.create :website, :own, unreachable_count: 2
    offer = FactoryGirl.create :offer, :approved
    website.offers << offer
    Offer.any_instance.expects(:index!).never
    single_worker.expects(:expire_and_create_assignments).never
    WebMock.stub_request(:head, 'www.example.com').to_timeout
    single_worker.perform website.id
    website.reload.unreachable_count.must_equal 3
  end

  it 'should work for a any offer if the website was unreachable before' do
    # setup
    website = FactoryGirl.create :website, :own, unreachable_count: 1
    offer = FactoryGirl.create :offer, :approved
    website.offers << offer
    # expectations
    Offer.any_instance.expects(:index!)
    WebMock.stub_request(:head, 'www.example.com').to_timeout
    single_worker.perform website.id
    offer.reload.must_be :website_unreachable?
    website.reload.unreachable_count.must_equal 2
    Assignment.last.message.must_equal '[Offer-website unreachable] | '\
                                       "#{website.url}"
  end

  it 'should ignore offers with reachable website and reset unreachable flag' do
    website = FactoryGirl.create :website, :own, unreachable_count: 1
    offer = FactoryGirl.create :offer, :approved
    website.offers << offer
    Offer.any_instance.expects(:index!).never
    single_worker.expects(:expire_and_create_assignments).never
    # stub request to return success
    WebMock.stub_request(:head, 'www.example.com')
    single_worker.perform website.id
    offer.reload.must_be :approved?
    website.reload.unreachable_count.must_equal 0
  end

  it 'should create an assignment for orga with 404 website and'\
     'not change state' do
    website = FactoryGirl.create :website, :own, unreachable_count: 1
    orga = FactoryGirl.create :organization, :approved, name: 'bazfuz'
    website.organizations << orga
    WebMock.stub_request(:head, 'www.example.com')
           .to_return(status: 404, body: '', headers: {}) # 404 stub
    WebMock.stub_request(:get, 'www.example.com')
           .to_return(status: 404, body: '', headers: {}) # 404 stub
    single_worker.perform website.id
    orga.must_be :approved?
    Assignment.last.message.must_equal '[Orga-website unreachable] | '\
                                       "#{website.url}"
  end

  describe '#url_unreachable_with_httparty?' do
    it 'must be true for 404 website' do
      website = FactoryGirl.create :website, :own, unreachable_count: 1
      WebMock.stub_request(:head, 'www.example.com')
             .to_return(status: 404, body: '', headers: {}) # 404 stub
      WebMock.stub_request(:get, 'www.example.com')
             .to_return(status: 404, body: '', headers: {}) # 404 stub
      single_worker.send(:url_unreachable_with_httparty?, website.ascii_url)
                   .must_equal true
    end

    it 'must be false for 200 website' do
      website = FactoryGirl.create :website, :own, unreachable_count: 1
      WebMock.stub_request(:head, 'www.example.com')
             .to_return(status: 200, body: '', headers: {})
      single_worker.send(:url_unreachable_with_httparty?, website.ascii_url)
                   .must_equal false
    end
  end
end
