# frozen_string_literal: true

module Lib
  module Macros
    module Debug
      def self.Breakpoint(*)
        unless Rails.env.test? || Rails.env.development?
          raise 'Remove Debug Macro!'
        end

        step = ->(operation, options) do
          # rubocop:disable Lint/Debugger
          binding.pry
          # rubocop:enable Lint/Debugger
          true
        end

        [step, name: 'debug']
      end
    end
  end
end
