# frozen_string_literal: true
# Monkeypatch clarat_base NextStep
require ClaratBase::Engine.root.join('app', 'models', 'next_step')

class NextStep < ActiveRecord::Base
  after_save :translate_if_text_en_changed

  private

  def translate_if_text_en_changed
    return if !text_en_changed? && !@new_record_before_save
    GengoCommunicator.new.create_translation_jobs(self, 'text')
  end
end
