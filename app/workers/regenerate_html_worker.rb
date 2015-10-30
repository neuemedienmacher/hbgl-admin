class RegenerateHtmlWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily.hour_of_day(0) }

  def perform
    Offer.approved.find_each do |offer|
      old = { description_html: offer.description_html,
              next_steps_html: offer.next_steps_html,
              opening_specification_html: offer.opening_specification_html }
      offer.generate_html!
      check_and_update(offer, old)
    end

    Organization.approved.find_each do |orga|
      old = { description_html: orga.description_html }
      orga.generate_html!
      check_and_update(orga, old)
    end
  end

  private

  def check_and_update object, old
    actual_changes = changes(object, old)
    object.update_columns actual_changes if actual_changes
  end

  def changes object, old
    news = {}
    old.each do |field, old_string|
      new_string = object.send(field)
      next if new_string == old_string
      news[field] = new_string
    end

    if news.keys.count > 0
      news[:updated_at] = Time.zone.now
      return news
    else
      return false
    end
  end
end
