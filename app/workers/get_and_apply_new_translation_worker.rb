# frozen_string_literal: true
class GetAndApplyNewTranslationWorker
  include Sidekiq::Worker

  def perform gengo_order_id
    gengo_order = GengoOrder.find(gengo_order_id)
    model, id, _field = gengo_order.expected_slug.split(':')

    if model.constantize.exists?(id)
      order = GengoCommunicator.new.fetch_order gengo_order.order_id
      continue_with_fetched_order order, gengo_order
    else
      gengo_order.delete
    end
  end

  private

  def continue_with_fetched_order order, gengo_order
    # ignore unfinished orders (total_job_count != approved_jobs_count)
    if order['total_jobs'].to_i == order['jobs_approved'].count
      get_and_apply_translations_of_order order, gengo_order.expected_slug
      # delete gengo_order
      gengo_order.delete
    end
  end

  def get_and_apply_translations_of_order order, expected_slug
    # store model_istance of single jobs
    updated_model = order['jobs_approved'].map do |job_id|
      get_and_apply_translation_job job_id.to_i, expected_slug
    end.first

    # reindex affected offers if category translation was updated
    if updated_model.class == Category
      updated_model.self_and_descendants.find_each.map do |category|
        category.offers.visible_in_frontend.each(&:index!)
      end
    end
  end

  def get_and_apply_translation_job job_id, expected_slug
    job = GengoCommunicator.new.fetch_job job_id

    # safety mechanism: gengo-slug must match the expected value
    raise 'invalid slug' if job['slug'] != "#{expected_slug}_#{job['lc_tgt']}"

    model, id, field = job['slug'].split(':')
    translated_instance = model.constantize.find(id)
    translation = job['body_tgt']

    translated_instance.send("#{field}=", translation)
    translated_instance.save!

    # return updated model instance ()
    translated_instance
  end
end
