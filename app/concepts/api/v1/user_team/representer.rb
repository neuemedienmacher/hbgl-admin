# frozen_string_literal: true
module API::V1
  module UserTeam
    module Representer
      class Show < API::V1::Default::Representer::Show
        type :user_teams

        property :name

        # collection :users, extend: API::V1::User::Representer::Show
        collection :users do
          property :id
          property :name, as: :label
        end
      end

      # class Show < API::V1::Default::Representer::Show
      #   # items extend: Show
      # end
    end
  end
end
