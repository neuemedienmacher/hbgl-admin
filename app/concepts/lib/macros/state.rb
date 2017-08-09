# frozen_string_literal: true
module Lib
  module Macros
    module State
      def self.Contract(settings)
        step = ->(operation, params:, **) do
          requested_event = state_change_param(params)

          operation['contract.default.class'] =
            if requested_event && settings[requested_event.to_sym]
              settings[requested_event.to_sym]
            else
              settings[:else]
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
