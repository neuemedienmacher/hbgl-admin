# frozen_string_literal: true
# Monkeypatch clarat_base Offer
require ClaratBase::Engine.root.join('app', 'models', 'opening')
# Opening Times of Offers
class Opening < ActiveRecord::Base
  include ReformedValidationHack

  # Callbacks
  before_hack :generate_name
  before_hack :calculate_sort_value

  def generate_name
    self.name = concat_day_and_times
  end

  # rails_admin can only sort by a single field, that's why we are creating an
  # imaginary time stamp that handles the sorting
  def calculate_sort_value
    return nil unless day
    dummy_time = dummy_time_for_day DAYS.index(day) + 1
    self.sort_value = (dummy_time.to_f * 100).to_i
  end

  private

  def concat_day_and_times
    if day && open && close
      "#{day.titleize} #{open.strftime('%H:%M')}-#{close.strftime('%H:%M')}"
    elsif day
      "#{day.titleize} (appointment)"
    end
  end

  # generate imaginary timestamp for a specific day
  def dummy_time_for_day day_nr
    if open && close
      hour = open.hour
      min = open.min
      sec = close.hour + close.min / 100.0
    else
      hour = min = sec = 0
    end
    Time.zone.local(1970, 1, day_nr, hour, min, sec, 0)
  end
end
