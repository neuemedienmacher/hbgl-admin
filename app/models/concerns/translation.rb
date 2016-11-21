# Monkeypatch clarat_base Translation
require ClaratBase::Engine.root.join('app', 'models', 'concerns', 'translation')
module Translation
  extend ActiveSupport::Concern
  # Admin specific methods

  # handled in observer after update and called on complete
  def generate_translations! fields = :all
    I18n.available_locales.each do |locale|
      if locale == :de # German translation is needed and thus done right away
        TranslationGenerationWorker.new.perform(locale, self.class.name, id)
      elsif no_state_or_not_initialized?
        TranslationGenerationWorker.perform_async(
          locale, self.class.name, id, fields
        )
      end
    end
    true
  end

  private

  def no_state_or_not_initialized?
    self.respond_to?(:aasm_state) == false || self.aasm_state != 'initialized'
  end
end
