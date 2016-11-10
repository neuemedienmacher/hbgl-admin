# EasyTranslate wrapper, using the Google Translate API
class GoogleTranslateCommunicator
  def self.get_translations original_texts_hash, to_locale, from_locale = 'de'
    results = EasyTranslate.translate(
      original_texts_hash.values, from: from_locale, to: to_locale,
                                  quotaUser: random_user)

    result_hash = {}

    original_texts_hash.keys.each_with_index do |key, index|
      result_hash[key] = results[index]
    end

    result_hash
  end

  # Provide GoogleAPI with a randomized string as user to prevent quota overflow
  def self.random_user
    rand.to_s[2..40]
  end
end
