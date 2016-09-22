# frozen_string_literal: true
module API::V1
  module Category
    module Representer
      class Show < API::V1::Default::Representer::Show
        property :name
        property :visible
        collection :children, extend: Show, if: (lambda do |opts|
          opts[:represented].children.any?
        end)
      end

      class Index < API::V1::Default::Representer::Index
        # items extend: Show
      end
    end
  end
end
