# frozen_string_literal: true
class CheckForNewTranslationsWorker
  include Sidekiq::Worker

  def perform
    ts = date_of_oldest_missing_translation.to_i
    jobs = GengoCommunicator.new.fetch_approved_jobs_after_timestamp ts
    jobs.each do |approved_job|
      GetAndApplyNewTranslationWorker.perform_async approved_job['job_id']
    end
  end

  private

  # retrieves the Date of the oldest missing translation from the affected
  # models in order to assure that we only pull the approved translation within
  # the required timeframe
  def date_of_oldest_missing_translation
    [
      Category.date_of_oldest_missing_translation,
      NextStep.date_of_oldest_missing_translation
    ].min
  end
end
