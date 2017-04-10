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

  collection :led_teams, decorator: UserTeam::Representer, class: UserTeam
  collection :user_teams, decorator: UserTeam::Representer, class: UserTeam
end
