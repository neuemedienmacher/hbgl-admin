# frozen_string_literal: true

# Monkeypatch clarat_base Category
require ClaratBase::Engine.root.join('app', 'models', 'category')

class Category < ApplicationRecord
  after_save :translate_if_name_en_changed
  after_create :translate_if_name_en_changed

  # Search
  include PgSearch
  pg_search_scope :search_pg,
                  against: %i[id name_de],
                  using: { tsearch: { prefix: true } }

  # Methods

  # alias for rails_admin_nestable
  singleton_class.send :alias_method, :arrange, :hash_tree

  # display name: each category gets suffixes for each section and
  # main categories get an additional asterisk
  def name_with_world_suffix_and_optional_asterisk
    return unless name
    sections_suffix = "(#{sections.map { |f| f.name.first }.join(',')})"
    name_de + (icon ? "#{sections_suffix}*" : sections_suffix)
  end

  private

  def translate_if_name_en_changed
    return if !saved_change_to_name_en? && !@new_record_before_save
    GengoCommunicator.new.create_translation_jobs(self, 'name')
  end
end
