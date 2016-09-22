# frozen_string_literal: true
module API::V1
  module Location
    module Representer
      class Show < API::V1::Default::Representer::Show
        property :display_name, as: :label
      end

      class Index < API::V1::Default::Representer::Index
        # items extend: Show
      end
    end
  end
end
