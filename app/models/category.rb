# frozen_string_literal: true
# Monkeypatch clarat_base Category
require ClaratBase::Engine.root.join('app', 'models', 'category')

class Category < ActiveRecord::Base
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
end
