# frozen_string_literal: true

class StatisticTransition::CreateIfNecessary < Trailblazer::Operation
  step :create_if_necessary

  def create_if_necessary(options, params:, current_user:, **)
    transition = ::StatisticTransition.where(params)

    options['model'] =
      if transition.count.zero?
        res = StatisticTransition::Create.(params, current_user: current_user)
        res['model']
      else
        transition.first
      end
  end
end
