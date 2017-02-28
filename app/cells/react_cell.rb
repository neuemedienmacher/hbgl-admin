# frozen_string_literal: true
class ReactCell < Cell::ViewModel
  def show
    render
  end

  private

  include ReactOnRailsHelper

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def props
    {
      user_teams: UserTeam.all,
      users: User.all.map { |user| User::Representer.new(user) },
      current_user: User::Representer.new(options[:current_user]),

      filters: Filter.all.map(&:attributes),
      productivity_goals: ProductivityGoal.all,
      statistics: Statistic.all,
      time_allocations: TimeAllocation.all,

      authToken: options[:form_authenticity_token],
      settings: {
        time_allocations: {
          start_year: User.order('created_at ASC').first.created_at.year
        },
        productivity_goals: {
          target_models: ProductivityGoal::TARGET_MODELS,
          target_field_names: ProductivityGoal::TARGET_FIELD_NAMES,
          target_field_values: ProductivityGoal::TARGET_FIELD_VALUES
        },
        assignments: {
          assignable_models: Assignment::ASSIGNABLE_MODELS
        }
      }
    }
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
end
