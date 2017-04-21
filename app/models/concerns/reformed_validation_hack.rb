# frozen_string_literal: true
# Polyfill to use Reform validations with old backend
# TODO: Remove every include of this with the model's usage in rails_admin
module ReformedValidationHack
  extend ActiveSupport::Concern

  included do
    before_validation do
      # run other callbacks before validations
      @@before_hacks[self.class.name]&.each do |func|
        self.send(func)
      end
      contract = hacky_contract.new(self)
      result = contract.validate(attributes)
      @errors = contract.errors
      result
    end

    def hacky_contract
      self.class::Contracts::Create
    end

    def self.before_hack function
      # rubocop:disable Style/ClassVars
      @@before_hacks ||= {}
      @@before_hacks[self.name] ||= []
      @@before_hacks[self.name] << function
      # rubocop:enable Style/ClassVars
    end
  end
end
