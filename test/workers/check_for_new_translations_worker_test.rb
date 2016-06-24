# frozen_string_literal: true
require_relative '../test_helper'

class CheckForNewTranslationsWorkerTest < ActiveSupport::TestCase
  let(:worker) { CheckForNewTranslationsWorker.new }

  it 'should fetch from the GengoCommunicator and spawn for every result' do
    GengoCommunicator.any_instance.expects(:fetch_approved_jobs_after_timestamp)
                     .returns([{ 'job_id' => 23 }, { 'job_id' => 43 }])
    GetAndApplyNewTranslationWorker.expects(:perform_async).with(23)
    GetAndApplyNewTranslationWorker.expects(:perform_async).with(43)
    worker.perform
  end
end
