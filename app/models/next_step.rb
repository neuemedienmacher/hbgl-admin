# frozen_string_literal: true

# Monkeypatch clarat_base NextStep
require ClaratBase::Engine.root.join('app', 'models', 'next_step')

class NextStep < ApplicationRecord
  after_save :translate_if_text_en_changed

  include ReformedValidationHack

  # Search
  include PgSearch
  pg_search_scope :search_pg,
                  against: %i[id text_de],
                  using: { tsearch: { prefix: true } }

  private

  def translate_if_text_en_changed
    return if !saved_change_to_text_en? && !@new_record_before_save
    GengoCommunicator.new.create_translation_jobs(self, 'text')
  end
end
