# frozen_string_literal: true
# Monkeypatch clarat_base Category
require ClaratBase::Engine.root.join('app', 'models', 'category')

class Category < ActiveRecord::Base
  after_save :translate_if_name_en_changed
  # Methods

  # alias for rails_admin_nestable
  singleton_class.send :alias_method, :arrange, :hash_tree

  # display name: each category gets suffixes for each section and
  # main categories get an additional asterisk
  def name_with_world_suffix_and_optional_asterisk
    return unless name
    sections_suffix = "(#{section_filters.map { |f| f.name.first }.join(',')})"
    name_de + (icon ? "#{sections_suffix}*" : sections_suffix)
  end

  def self.date_of_oldest_missing_translation
    sql_string = (I18n.available_locales - [:de, :en]).map do |locale|
      # INFO: Unfortunately, most of our data is not nil but blank :/
      "name_#{locale} IS null OR name_#{locale}='' "
    end.join(' OR ')
    Category.where(sql_string).minimum(:created_at) || Time.zone.now
  end

  private

  def translate_if_name_en_changed
    return if !name_en_changed? && !@new_record_before_save
    GengoCommunicator.new.create_translation_jobs(self, 'name')
  end
end
