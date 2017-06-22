# frozen_string_literal: true
module Lib
  module Macros
    module Debug
      def self.Breakpoint(*)
        unless Rails.env.test? || Rails.env.development?
          raise "Remove Debug Macro!"
        end

        step = ->(operation, options) do
          binding.pry
          true
        end

        [step, name: 'debug']
      end
    end
  end
end
