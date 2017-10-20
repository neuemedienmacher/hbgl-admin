# frozen_string_literal: true

# Monkeypatch clarat_base Category
require ClaratBase::Engine.root.join('app', 'models', 'tag')

class Tag < ApplicationRecord
  after_save :translate_if_name_en_changed
  # Methods

  include ReformedValidationHack

  # Search
  include PgSearch
  pg_search_scope :search_pg,
                  against: %i[id name_de name_en],
                  using: { tsearch: { prefix: true } }

  private

  def translate_if_name_en_changed
    return if !saved_change_to_name_en? && !@new_record_before_save
    GengoCommunicator.new.create_translation_jobs(self, 'name')
  end
end
