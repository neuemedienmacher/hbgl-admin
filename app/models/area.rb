# frozen_string_literal: true
# Monkeypatch clarat_base Area
require ClaratBase::Engine.root.join('app', 'models', 'area')
# Bounding Box around an area that a non-personal offer provides service to.
class Area < ActiveRecord::Base
  include ReformedValidationHack
end
