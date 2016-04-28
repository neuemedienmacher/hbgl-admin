module API::V1
  module Statistic
    module Representer
      class Show < API::V1::Default::Representer::Show
        property :topic
        property :user_id
        property :x
        property :y
      end

      class Index < API::V1::Default::Representer::Index
        items extend: Show
      end
    end
  end
end
