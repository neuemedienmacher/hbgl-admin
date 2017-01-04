# EasyTranslate wrapper, using the Google Translate API
class GoogleTranslateCommunicator
  def self.get_translations original_texts_hash, to_locale, from_locale = 'de'
    # NOTE: additional Logging to find error - remove later!!
    logger = Logger.new(STDOUT)
    tmp_user = random_user
    logger.info "Triggering EasyTranslate with from: #{from_locale}, to: #{to_locale}, user: #{tmp_user} and original_texts_hash: #{original_texts_hash}"
    results = EasyTranslate.translate(
      original_texts_hash.values, from: from_locale, to: to_locale,
                                  quotaUser: tmp_user)

    result_hash = {}
    # NOTE: additional Logging to find error - remove later!!
    logger.info "Results from EasyTranslate: #{results}"
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
