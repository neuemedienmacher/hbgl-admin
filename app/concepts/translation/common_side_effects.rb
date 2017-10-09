# frozen_string_literal: true

module Translation
  module CommonSideEffects
    module HumanChangeFields
      def reset_source_and_possibly_outdated_if_changes_by_human(options)
        if options['changes_by_human']
          options['contract.default'].source = 'researcher'
          options['contract.default'].possibly_outdated = false
        end
        true
      end
    end
  end
end
