# frozen_string_literal: true
# Monkeypatch clarat_base NextStep
require ClaratBase::Engine.root.join('app', 'models', 'next_step')

class NextStep < ActiveRecord::Base
  after_save :translate_if_text_en_changed

  def self.date_of_oldest_missing_translation
    sql_string = (I18n.available_locales - [:de, :en]).map do |locale|
      # INFO: Unfortunately, most of our data is not nil but blank :/
      "text_#{locale} IS null OR text_#{locale}='' "
    end.join(' OR ')
    NextStep.where(sql_string).minimum(:created_at)
  end

  private

  def translate_if_text_en_changed
    return if !text_en_changed? && !@new_record_before_save
    GengoCommunicator.new.create_translation_jobs(self, 'text')
  end
end
