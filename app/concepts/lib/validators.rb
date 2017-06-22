# frozen_string_literal: true
module Lib
  module Validators
    def self.UnnestedPresence(field)
      ->() {
        field_value = send(field)
        if (field_value.nil? || field_value.empty?)
          errors.add field, I18n.t('errors.messages.empty')
        elsif field_value == 'nested'
          send("#{field}=", nil)
        end
      }
    end
  end
end
