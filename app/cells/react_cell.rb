# frozen_string_literal: true
class ReactCell < Cell::ViewModel
  def show
    render
  end

  private

  include ReactOnRailsHelper

  # rubocop:disable Metrics/MethodLength
  def props
    {
      user_teams: UserTeam.all,
      users: User.all.map { |user| User::Representer.new(user) },
      current_user: User::Representer.new(options[:current_user]),

      filters: Filter.all.map(&:attributes),

      authToken: options[:form_authenticity_token],
      settings: {
        time_allocations: {
          start_year: User.order('created_at ASC').first.created_at.year
        },
        statistic_charts: {
          target_models: StatisticChart::TARGET_MODELS,
          target_field_names: StatisticChart::TARGET_FIELD_NAMES,
          target_field_values: StatisticChart::TARGET_FIELD_VALUES
        },
        assignments: {
          assignable_models: Assignment::ASSIGNABLE_MODELS
        }
      }
    }
  end
  # rubocop:enable Metrics/MethodLength
end
