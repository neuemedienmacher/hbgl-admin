# frozen_string_literal: true
module API::V1
  module User
    module Representer
      class Show < API::V1::Default::Representer::Show
        property :name, as: :label
      end

      class Index < API::V1::Default::Representer::Index
        # items extend: Show
      end

      class Update < Roar::Decorator
        include Roar::JSON::JSONAPI
        type :users
        property :id
        property :current_team_id
      end
    end
  end
end
