module EasyTranslate
  STANDARD_TRANSLATION = 'GET READY FOR CANADA'

  def self.translate *attrs
    if attrs[0].is_a? Array
      attrs[0].map { |_e| translation }
    else
      standard_translation
    end
  end

  def self.translation
    @translation || STANDARD_TRANSLATION
  end

  def self.translated_with translation_string
    @translation = translation_string
    yield
    @translation = nil
  end
end
