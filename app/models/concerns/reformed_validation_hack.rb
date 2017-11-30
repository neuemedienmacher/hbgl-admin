# frozen_string_literal: true

# Polyfill to use Reform validations with old backend
# TODO: Remove every include of this with the model's usage in rails_admin
module ReformedValidationHack
  extend ActiveSupport::Concern

  included do
    before_validation(on: :create) { _rvhack_validate(:create) }
    before_validation(on: :update) { _rvhack_validate(:update) }

    def _rvhack_validate event
      contract = _rvhacky_contract_for(event).new(self)
      result = contract.validate(attributes)
      @errors = contract.errors
      result
    end

    def _rvhacky_contract_for event
      if event == :update && defined?(self.class::Contracts::Update)
        self.class::Contracts::Update
      else
        self.class::Contracts::Create
      end
    end

    # Epic Hax: don't use model validations for operation persisting
    def save(options = {})
      # maybe 'macros/nested.rb' to only hax nesting operations
      if caller.select { |s| s.include?('trailblazer/operation/persist') }.any?
        super options.merge(validate: false)
      else
        super options
      end
    end
  end
end
