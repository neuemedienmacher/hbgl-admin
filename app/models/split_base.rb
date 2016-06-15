# frozen_string_literal: true
require ClaratBase::Engine.root.join('app', 'models', 'split_base')

class SplitBase < ActiveRecord::Base
  # Methods
  delegate :name, to: :organization, prefix: true, allow_nil: true
  delegate :name, to: :solution_category, prefix: true, allow_nil: true

  def display_name
    "#{organization_name} || #{title} || #{solution_category_name} ||"\
      " #{clarat_addition}"
  end
end
