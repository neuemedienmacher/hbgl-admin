# frozen_string_literal: true
module ContractTestUtils
  def must_validate_presence_of(property)
    set property, nil
    assert_contract_error(property, 'blank')
  end

  def wont_validate_presence_of(property)
    set property, 'a'
    refute_contract_error(property, 'blank')
  end

  def must_validate_length_of property, options
    if options[:maximum]
      set property, 'a' * options[:maximum]
      refute_contract_error(property, 'too_long', count: options[:maximum])
      set property, 'a' * (options[:maximum] + 1)
      assert_contract_error(property, 'too_long', count: options[:maximum])
    end
  end

  def must_validate_uniqueness_of property, existing_property_value
    set property, SecureRandom.base64
    refute_contract_error(property, 'taken')
    set property, existing_property_value
    assert_contract_error(property, 'taken')
  end

  private

  def set(property, value)
    subject.send("#{property}=", value)
  end

  def assert_contract_error(property, i18n_key, i18n_options = {})
    subject.errors.delete property
    subject.wont_be :valid?
    subject.errors.messages.keys.must_include(
      property, "Error messages did not include #{property}"
    )
    subject.errors.messages[property].must_include(
      I18n.t("errors.messages.#{i18n_key}", i18n_options)
    )
  end

  def refute_contract_error(property, i18n_key, i18n_options = {})
    subject.errors.delete property
    subject.valid?
    !subject.errors.messages[property] ||
      subject.errors.messages[property].wont_include(
        I18n.t("errors.messages.#{i18n_key}", i18n_options)
      )
  end
end
