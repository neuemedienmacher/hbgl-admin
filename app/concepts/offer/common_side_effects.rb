# frozen_string_literal: true

module Offer::CommonSideEffects
  def set_next_steps_sort_value(options, model:, **)
    options['contract.default'].next_steps.map(&:id).each_with_index do |id, i|
      connector = model.next_steps_offers.find_by(next_step_id: id)
      connector.update_column(:sort_value, i) if connector.sort_value != i
    end
    true
  end
end
