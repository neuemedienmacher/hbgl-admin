# frozen_string_literal: true
class CheckForNewTranslationsWorker
  include Sidekiq::Worker

  def perform
    jobs = GengoCommunicator.new.fetch_approved_jobs
    jobs.each do |approved_job|
      GetAndApplyNewTranslationWorker.perform_async approved_job['job_id']
    end
  end
end
