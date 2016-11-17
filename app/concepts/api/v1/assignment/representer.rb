# frozen_string_literal: true
module API::V1
  module Assignment
    module Representer
      class Show < API::V1::Default::Representer::Show
        type :assignments

        property :assignable_id
        property :assignable_type
        property :assignable_field_type
        property :creator_id
        property :creator_team_id
        property :reciever_id
        property :reciever_team_id
        property :message
        property :parent_id
        property :aasm_state
        property :created_at
        property :updated_at
      end
    end
  end
end
