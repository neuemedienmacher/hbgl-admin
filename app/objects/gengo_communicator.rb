# frozen_string_literal: true

class GengoCommunicator
  TIER = 'standard'

  def initialize
    @connection = Gengo::API.new(
      public_key: Rails.application.secrets.gengo['public_key'],
      private_key: Rails.application.secrets.gengo['private_key'],
      sandbox: !Rails.env.production?
    )
    @translatable_locales = I18n.available_locales - [:de, :en]
  end

  def create_translation_jobs model, field
    jobs = []
    @translatable_locales.each do |locale|
      jobs << {
        tier: TIER, type: 'text', max_chars: 255, auto_approve: 1,
        lc_src: 'en', lc_tgt: locale.to_s,
        body_src: model.send("#{field}_en"),
        slug: "#{model.class.name}:#{model.id}:#{field}_#{locale}",
        comment:  "It's for a web app to help refugees in Germany to find help.
                  Please use a very simple / easy to understand language"
        purpose:  "Web content. Describing help for refugees in Germany",
        tone:     "Friendly. Please use easy to understand language."
      }
    end

    @connection.postTranslationJobs(jobs: jobs)
  end

  def fetch_approved_jobs
    answer = @connection.getTranslationJobs(status: 'approved')
    answer['response']
  end

  def fetch_job job_id
    answer = @connection.getTranslationJob(id: job_id)
    answer['response']['job']
  end
end
