# frozen_string_literal: true
require ClaratBase::Engine.root.join('app', 'models', 'split_base')

class SplitBase < ActiveRecord::Base
  def display_name
    "#{organization&.name} - #{solution_category&.name} -"\
      " #{title} - #{clarat_addition}"
  end
end
