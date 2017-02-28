# frozen_string_literal: true
require 'representable/json'

class User::Representer < Representable::Decorator
  include Representable::JSON

  property :id
  property :name
  property :email
  property :role
  property :current_team_id
  property :user_team_ids
end
