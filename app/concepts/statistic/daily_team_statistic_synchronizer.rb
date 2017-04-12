# frozen_string_literal: true
# PORO that aggregates daily user-statistics of a year to daily team-statistics
class Statistic::DailyTeamStatisticSynchronizer
  def initialize(team_id, year)
    @team = UserTeam.find(team_id)
    @year = year.to_i
  end

  def record!
    Statistic.transaction do
      statistics = all_statistics_of_users_in_year
      properties = { time_frame: 'daily' }

      # iterate uniq models
      statistics.pluck(:model).uniq.map do |statistic_model|
        properties = properties.merge(model: statistic_model)
        model_statistics = statistics.where(properties)
        # iterate uniq fields of model
        model_statistics.pluck(:field_name).uniq.map do |statistic_field|
          properties = properties.merge(field_name: statistic_field)
          field_statistics = model_statistics.where(properties)
          iterate_statistics_by_start_and_end_value(field_statistics, properties)
        end
      end
    end
  end

  private

  def all_statistics_of_users_in_year
    min_date = Date.new(@year, 1, 1)
    max_date = Date.new(@year, 12, 31)
    user_ids = recursive_user_ids_of_team(@team).uniq

    Statistic
      .where(trackable_id: user_ids)
      .where(trackable_type: 'User')
      .where(time_frame: 'daily')
      .where('date >= ?', min_date)
      .where('date <= ?', max_date)
  end

  def recursive_user_ids_of_team team
    (team.users.pluck(:id) + team.children.map do |child_team|
      recursive_user_ids_of_team child_team
    end).flatten
  end

  def find_or_initialize properties
    Statistic.where(properties).first || Statistic.new(properties)
  end

  def delete_team_statistics_of_irrelevant_dates props, relevant_dates
    Statistic.where.not(date: relevant_dates).where(
      props.merge(trackable_id: @team.id, trackable_type: 'UserTeam')
    ).delete_all
  end

  # iterate uniq combination of start & end_value of field (of model)
  def iterate_statistics_by_start_and_end_value stats, props
    stats.pluck(:field_start_value, :field_end_value).uniq.map do |start, ending|
      properties = props.merge(field_start_value: start, field_end_value: ending)
      relevant_statistics = stats.where(properties)
      iterate_statistics_by_date relevant_statistics, properties
    end
  end

  # iterate evey uniq day of the statistics
  def iterate_statistics_by_date statistics, props
    relevant_dates = statistics.pluck(:date).uniq
    # delete all existing team-statistics of dates, that are no longer needed
    delete_team_statistics_of_irrelevant_dates props, relevant_dates
    # then iterate the current dates to update/create the statistics
    relevant_dates.map do |statistic_date|
      properties = props.merge(date: statistic_date)
      stats = statistics.where(properties)
      select_statistics_and_update_or_create_team_statistic stats, properties
    end
  end

  def select_statistics_and_update_or_create_team_statistic statistics, props
    date_statistics = statistics.where(props)

    team_statistic = find_or_initialize(
      props.merge(trackable_id: @team.id, trackable_type: 'UserTeam')
    )

    team_statistic.count = date_statistics.pluck(:count).sum
    team_statistic.save!
  end
end
