require 'representable/json'

class UserRepresenter < Representable::Decorator
  include Representable::JSON

  property :id
  property :name
  property :email
  property :role
  property :current_team_id
  property :user_team_ids
end
