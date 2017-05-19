# frozen_string_literal: true
class ReactCell < Cell::ViewModel
  def show
    render
  end

  private

  include ReactOnRailsHelper

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def props
    {
      'user-teams': API::V1::UserTeam::Representer::Show.for_collection.new(UserTeam.all).to_hash,
      users: API::V1::User::Representer::Show.for_collection.new(User.all).to_hash,
      'current-user-id': options[:current_user].id,

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
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
end
