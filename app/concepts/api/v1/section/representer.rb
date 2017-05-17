# frozen_string_literal: true
module API::V1
  module Section
    module Representer
      class Show < API::V1::Default::Representer::Show
        type :sections

        property :label, getter: ->(section) do
          section[:represented].identifier
        end

        property :identifier
        property :name
      end

      class Index < Show
      end
    end
  end
end
