# frozen_string_literal: true

class Opening::Create < Trailblazer::Operation
  step Model(::Opening, :new)
  step Policy::Pundit(PermissivePolicy, :create?)

  step Contract::Build(constant: Opening::Contracts::Create)
  step Contract::Validate()
  step :generate_name
  step :calculate_sort_value
  step Contract::Persist()

  def generate_name options
    options['model'].name =
      concat_day_and_times opening_hash(options['contract.default'])
  end

  # rails_admin can only sort by a single field, that's why we are creating an
  # imaginary time stamp that handles the sorting
  def calculate_sort_value options
    dummy_time = dummy_time_for_day opening_hash(options['contract.default'])
    options['model'].sort_value = (dummy_time.to_f * 100).to_i
  end

  private

  def concat_day_and_times(day:, open:, close:)
    if day && open && close
      "#{day.titleize} #{open}-#{close}"
    elsif day
      "#{day.titleize} (appointment)"
    end
  end

  # generate imaginary timestamp for a specific day
  def dummy_time_for_day(day:, open:, close:)
    if open && close
      hour = open.first(2).to_i
      min = open.last(2).to_i
      sec = close.first(2).to_i + close.last(2).to_i / 100.0
    else
      hour = min = sec = 0
    end
    Time.zone.local(1970, 1, day_nr(day), hour, min, sec, 0)
  end

  def opening_hash(contract)
    { day: contract.day, open: contract.open, close: contract.close }
  end

  def day_nr(day)
    Opening::DAYS.index(day) + 1
  end
end
