# frozen_string_literal: true
require_relative '../test_helper'

class GetAndApplyNewTranslationWorkerTest < ActiveSupport::TestCase
  let(:worker) { GetAndApplyNewTranslationWorker.new }

  it 'should fetch from the GengoCommunicator and apply the changes' do
    order = GengoOrder.create order_id: 123, expected_slug: 'Category:1:name'
    GengoCommunicator.any_instance.expects(:fetch_order).with(123).returns(
      'total_jobs' => '2', 'jobs_approved' => %w(1 2)
    )
    GengoCommunicator.any_instance.expects(:fetch_job).with(1).returns(
      'body_tgt' => 'fr(GET READY FOR CANADA)', 'slug' => 'Category:1:name_fr',
      'lc_tgt' => 'fr'
    )
    GengoCommunicator.any_instance.expects(:fetch_job).with(2).returns(
      'body_tgt' => 'ar(GET READY FOR CANADA)', 'slug' => 'Category:1:name_ar',
      'lc_tgt' => 'ar'
    )
    Category.find(1).name_fr.wont_equal 'fr(GET READY FOR CANADA)'
    Category.find(1).name_ar.wont_equal 'ar(GET READY FOR CANADA)'
    GengoOrder.any_instance.expects(:delete).once
    worker.perform order.id
    Category.find(1).name_fr.must_equal 'fr(GET READY FOR CANADA)'
    Category.find(1).name_ar.must_equal 'ar(GET READY FOR CANADA)'
  end

  it 'should ignore uncompleted orders' do
    order = GengoOrder.create order_id: 123, expected_slug: 'Category:1:name'
    GengoCommunicator.any_instance.expects(:fetch_order).with(123).returns(
      'total_jobs' => '2', 'jobs_approved' => ['1']
    )
    GengoCommunicator.any_instance.expects(:fetch_job).never
    Category.find(1).name_fr.wont_equal 'fr(GET READY FOR CANADA)'
    GengoOrder.any_instance.expects(:delete).never
    worker.perform order.id
    Category.find(1).name_fr.wont_equal 'fr(GET READY FOR CANADA)'
  end

  it 'should process completed order but ignore its jobs with wrong slug' do
    order = GengoOrder.create order_id: 123, expected_slug: 'Category:1:name'
    GengoCommunicator.any_instance.expects(:fetch_order).with(123).returns(
      'total_jobs' => '1', 'jobs_approved' => ['1']
    )
    GengoCommunicator.any_instance.expects(:fetch_job).with(1).returns(
      'body_tgt' => 'fr(GET READY FOR CANADA)', 'slug' => 'Offer:1:description',
      'lc_tgt' => 'fr'
    )
    Category.find(1).name_fr.wont_equal 'fr(GET READY FOR CANADA)'
    GengoOrder.any_instance.expects(:delete).never
    assert_raises(RuntimeError) { worker.perform order.id }
    Category.find(1).name_fr.wont_equal 'fr(GET READY FOR CANADA)'
  end
end
