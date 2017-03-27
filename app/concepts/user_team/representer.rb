# frozen_string_literal: true
require 'representable/json'

class UserTeam::Representer < Representable::Decorator
  include Representable::JSON

  property :id
  property :name
  property :classification
  property :user_ids
end
