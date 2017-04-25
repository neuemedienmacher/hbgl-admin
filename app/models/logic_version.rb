# frozen_string_literal: true
# Monkeypatch clarat_base Location
require ClaratBase::Engine.root.join('app', 'models', 'logic_version')
# Version of business-internal entry logic
class LogicVersion < ActiveRecord::Base
  include ReformedValidationHack
end
