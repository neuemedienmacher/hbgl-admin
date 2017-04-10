# frozen_string_literal: true
require 'representable/json'

class UserTeam::Representer < Representable::Decorator
  include Representable::JSON

  property :id
  property :name
  property :classification
  property :user_ids
  property :lead_id

  property :parent_id
  collection :children, decorator: UserTeam::Representer, class: UserTeam
end
