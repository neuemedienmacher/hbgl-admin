# frozen_string_literal: true
# Polyfill to use Reform validations with old backend
# TODO: Remove every include of this with the model's usage in rails_admin
module ReformedValidationHack
  extend ActiveSupport::Concern

  included do
    before_validation do
      contract = hacky_contract.new(self)
      result = contract.validate(attributes)
      @errors = contract.errors
      result
    end

    def hacky_contract
      self.class::Contracts::Create
    end
  end
end
