# frozen_string_literal: true

# PORO for finding an exact matching TA or one that's historically closest
class TimeAllocation::DynamicFind
  def initialize(user_id, year, week_number)
    @user_id = user_id
    @year = year
    @week_number = week_number
  end

  def find_or_initialize
    allocation = ::TimeAllocation.find_by(exact_match_attributes)

    unless allocation
      historical_allocation = find_closest_historical_match
      allocation = ::TimeAllocation.new(exact_match_attributes)
      allocation.desired_wa_hours = historical_allocation.desired_wa_hours
    end

    allocation
  end

  private

  def exact_match_attributes
    {
      user_id: @user_id,
      year: @year,
      week_number: @week_number
    }
  end

  def find_closest_historical_match
    match = ::TimeAllocation
            .where(user_id: @user_id)
            .where('year <= ?', @year)
            .where('week_number <= ?', @week_number)
            .order('year DESC, week_number DESC')
            .first

    raise NoHistoricalMatchError unless match
    match
  end

  class NoHistoricalMatchError < StandardError
  end
end
