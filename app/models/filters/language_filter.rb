# frozen_string_literal: true
# Monkeypatch clarat_base OfferTranslation
require ClaratBase::Engine.root.join('app', 'models', 'filters/language_filter')
class LanguageFilter < Filter
  include ReformedValidationHack
end
