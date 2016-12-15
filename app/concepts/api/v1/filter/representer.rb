# frozen_string_literal: true
module API::V1
  module Filter
    module Representer
      class Show < API::V1::Default::Representer::Show
        type :filters

        property :label, getter: ->(filter) do
          filter[:represented].identifier
        end

        property :identifier
        property :name
      end

      class Index < Show
      end
    end
  end
end
