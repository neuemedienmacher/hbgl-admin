# frozen_string_literal: true
module Lib
  module Macros
    module State
      def self.Contract(options_or_contract)
        step = ->(operation, params:, **) do
          requested_event = state_change_param(params)

          operation['contract.default.class'] =
            if requested_event && options_or_contract[requested_event.to_sym]
              options_or_contract[requested_event.to_sym]
            elsif options_or_contract.is_a?(Hash) && options_or_contract[:else]
              options_or_contract[:else]
            else
              options_or_contract
            end

          true
        end

        [step, name: 'state.contract.set']
      end

      private_class_method

      def self.state_change_param(params)
        params['meta'] && params['meta']['commit']
      end
    end
  end
end
