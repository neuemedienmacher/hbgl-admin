# frozen_string_literal: true
class ProductivityGoal::ShowCell < Cell::Concept
  def show
    render
  end

  private

  include ReactOnRailsHelper

  def props
    {
      productivity_goal: model,
      statistics: Statistic.where(
        model: model.target_model,
        field_name: model.target_field_name,
        field_end_value: model.target_field_value
      ).all,
      user_teams: [model.user_team],
      users: model.user_team.users
    }
  end
end
