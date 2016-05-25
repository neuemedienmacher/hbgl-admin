# frozen_string_literal: true
class GetAndApplyNewTranslationWorker
  include Sidekiq::Worker

  def perform job_id
    job = GengoCommunicator.new.fetch_job job_id
    model, id, field = job['slug'].split(':')
    translated_instance = model.constantize.find(id)
    translation = job['body_tgt']

    translated_instance.send("#{field}=", translation)
    translated_instance.save!
  end
end
