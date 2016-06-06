# frozen_string_literal: true
require ClaratBase::Engine.root.join('app', 'models', 'split_base')

class SplitBase < ActiveRecord::Base
  def display_name
    "#{organization&.name} || #{title} || #{solution_category&.name} ||"\
      " #{clarat_addition}"
  end
end
