# frozen_string_literal: true
module API::V1
  module Organization
    module Representer
      class Show < API::V1::Default::Representer::Show
        property :name, as: :label
      end

      class Index < API::V1::Default::Representer::Index
        items extend: Show
      end
    end
  end
end
