# frozen_string_literal: true
# PORO that aggregates daily statistic for a given week and comp them into
# weekly ones
class Statistic::WeeklyStatisticAggregator
  def initialize(user_id, year, week_number, actual_wa_hours)
    @user_id = user_id.to_i
    @year = year.to_i
    @week_number = week_number.to_i
    @actual_wa_hours = actual_wa_hours.to_i
  end

  def record!
    Statistic.transaction do
      sorted_statistics_from_week.each do |key, daily_statistic_array|
        Statistic.create!(
          deserialize_goal_unique_key(key).merge(
            user_id: @user_id,
            date: Date.commercial(@year, @week_number, 7),
            time_frame: 'weekly',
            count: count_for_daily_statistics(daily_statistic_array)
          )
        )
      end
    end
  end

  private

  def all_statistics_from_week
    min_date = Date.commercial(@year, @week_number)
    max_date = min_date + 6.days

    Statistic
      .where(user_id: @user_id)
      .where('date >= ?', min_date)
      .where('date <= ?', max_date)
  end

  def sorted_statistics_from_week
    sort_hash = {}
    all_statistics_from_week.each do |statistic|
      key = serialize_goal_unique_key(statistic)
      sort_hash[key] ||= []
      sort_hash[key].push statistic
    end
    sort_hash
  end

  def serialize_goal_unique_key statistic
    [
      statistic.user_team_id, statistic.model, statistic.field_name,
      statistic.field_start_value, statistic.field_end_value
    ]
  end

  def deserialize_goal_unique_key key
    {
      user_team_id: key[0],
      model: key[1],
      field_name: key[2],
      field_start_value: key[3],
      field_end_value: key[4]
    }
  end

  # The sum of all encompassed statistics divided by the time worked that week
  def count_for_daily_statistics array
    array.map(&:count).reduce(0, :+) / @actual_wa_hours
  end
end
