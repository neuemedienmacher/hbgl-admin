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
      'user-teams': API::V1::UserTeam::Representer::Show.for_collection.new(
        UserTeam.all
      ).to_hash,
      users: API::V1::User::Representer::Show.for_collection.new(
        User.all
      ).to_hash,
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
          assignable_models: Assignment::ASSIGNABLE_MODELS,
          topics: Assignment::TOPICS
        },
        editable_states: {
          organizations: Organization::EDITABLE_IN_STATES,
          offers: Offer::EDITABLE_IN_STATES
        },
        actions: {
          organizations: Organization.aasm.events.map(&:name),
          offers: Offer.aasm.events.map(&:name),
          divisions: %w[mark_as_done mark_as_not_done]
        }
      }
    }
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
end
