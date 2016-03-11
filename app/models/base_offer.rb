require ClaratBase::Engine.root.join('app', 'models', 'base_offer')

class BaseOffer < ActiveRecord::Base
  def display_name
    "#{name} (#{id})"
  end
end
