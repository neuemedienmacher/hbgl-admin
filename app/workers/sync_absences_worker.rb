# frozen_string_literal: true
class SyncAbsencesWorker
  include Sidekiq::Worker

  def perform
    absences = AbsenceCommunicator.new.get_all_vacations_and_sickness_absences
    Absence.transaction do
      Absence.update_all sync: false

      absences.each do |api_absence|
        user = User.find_by!(email: api_absence['assignedTo']['email'])
        db_absence_attributes = {
          starts_at: api_absence['start'], ends_at: api_absence['end'],
          user_id: user.id
        }
        existing_db_absence = Absence.where(db_absence_attributes).first

        if existing_db_absence
          existing_db_absence.update_column sync: true
        else
          Absence.create! db_absence_attributes
        end
      end

      # Delete absences that were deleted on API
      Absence.where(sync: false).delete_all!
    end
  end

  private

  def get_and_apply_translations_of_order order, expected_slug
    # store model_istance of single jobs
    updated_model = order['jobs_approved'].map do |job_id|
      get_and_apply_translation_job job_id.to_i, expected_slug
    end.first

    # reindex affected offers if category translation was updated
    if updated_model.class == Category
      updated_model.self_and_descendants.find_each.map do |category|
        category.offers.approved.each(&:index!)
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
