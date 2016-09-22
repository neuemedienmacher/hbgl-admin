# frozen_string_literal: true
class ReactCell < Cell::ViewModel
  def show
    render
  end

  private

  include ReactOnRailsHelper

  def props
    {
      user_teams: UserTeam.all,
      users: User.all.map { |user| UserRepresenter.new(user) },
      current_user: UserRepresenter.new(options[:current_user]),

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
        }
      }
    }
  end
end
