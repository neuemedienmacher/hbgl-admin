# frozen_string_literal: true
require_relative '../test_helper'

class GetAndApplyNewTranslationWorkerTest < ActiveSupport::TestCase
  let(:worker) { GetAndApplyNewTranslationWorker.new }

  it 'should fetch from the GengoCommunicator and apply the changes' do
    GengoCommunicator.any_instance.expects(:fetch_job).with(123).returns(
      'body_tgt' => 'GET READY FOR CANADA', 'slug' => 'Category:1:name_fr'
    )
    Category.find(1).name_fr.wont_equal 'GET READY FOR CANADA'
    worker.perform 123
    Category.find(1).name_fr.must_equal 'GET READY FOR CANADA'
  end
end
