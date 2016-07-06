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
      jobs << generate_job_hash(model, field, locale)
    end

    send_jobs_and_save_order_id jobs, model, field
  end

  def fetch_job job_id
    answer = @connection.getTranslationJob(id: job_id)
    answer['response']['job']
  end

  def fetch_order order_id
    answer = @connection.getTranslationOrderJobs(order_id: order_id)
    answer['response']['order']
  end

  private

  def send_jobs_and_save_order_id jobs, model, field
    post_answer = @connection.postTranslationJobs(jobs: jobs)
    order_id = post_answer['response']['order_id'].to_i
    expected_slug_prefix = "#{model.class.name}:#{model.id}:#{field}"

    GengoOrder.create order_id: order_id, expected_slug: expected_slug_prefix
  end

  def generate_job_hash model, field, locale
    {
      tier: TIER, type: 'text', max_chars: 255, auto_approve: 1,
      comment: 'It\'s for a web app to help refugees in Germany to find'\
               ' help. Please use very simple / easy to understand'\
               ' language.',
      purpose: 'Web content. Describing help for refugees in Germany',
      tone:    'Friendly, Informal (first name basis)',
      lc_src: 'en', lc_tgt: locale.to_s,
      body_src: model.send("#{field}_en"),
      slug: "#{model.class.name}:#{model.id}:#{field}_#{locale}"
    }
  end
end
