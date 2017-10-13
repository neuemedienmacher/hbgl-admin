# frozen_string_literal: true

require ClaratBase::Engine.root.join('app', 'models', 'split_base')

class SplitBase < ApplicationRecord
  # Methods
  # delegate :name, to: :organizations, prefix: true, allow_nil: true
  delegate :name, to: :solution_category, prefix: true, allow_nil: true

  include ReformedValidationHack

  include PgSearch
  pg_search_scope :search_pg,
                  against: %i[id clarat_addition comments label
                              solution_category_id],
                  using: { tsearch: { prefix: true } }
end
