# frozen_string_literal: true

module Lib
  module Validators
    def self.UnnestedPresence(field)
      ->() do
        value = send(field)
        if !value || value.respond_to?(:empty) && value.empty?
          errors.add field, I18n.t('errors.messages.empty')
        elsif value == 'nested'
          send("#{field}=", nil)
        end
      end
    end
  end
end
