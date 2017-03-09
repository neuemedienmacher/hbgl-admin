# frozen_string_literal: true
module API::V1
  module Location
    module Representer
      class Show < API::V1::Default::Representer::Show
        property :display_name, as: :label
      end
    end
  end
end
