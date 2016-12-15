module Translations
  extend ActiveSupport::Concern
  included do
    # handled in observer after update and called on complete
    def generate_translations! fields = :all
      I18n.available_locales.each do |locale|
        if locale == :de # German translation is needed and thus done right away
          TranslationGenerationWorker.new.perform(locale, self.class.name, id)
        elsif no_state_or_approved?
          TranslationGenerationWorker.perform_async(
            locale, self.class.name, id, fields
          )
        end
      end
      true
    end

    private

    def no_state_or_approved?
      self.respond_to?(:aasm_state) == false ||
        %w(approved all_done).include?(self.aasm_state)
    end
  end
end
