# frozen_string_literal: true
class ProductivityGoal::NewCell < Cell::Concept
  def show
    render
  end

  private

  include ReactOnRailsHelper

  def props
    {
      teams: UserTeam.all,
      target_models: ProductivityGoal::TARGET_MODELS,
      target_field_names: ProductivityGoal::TARGET_FIELD_NAMES,
      target_field_values: ProductivityGoal::TARGET_FIELD_VALUES
    }
  end
end
