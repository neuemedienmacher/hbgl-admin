# frozen_string_literal: true
module API::V1
  module Website
    module Representer
      class Show < API::V1::Default::Representer::Show
        type :websites

        property :label, getter: ->(website) do
          website[:represented].url
        end
        property :host
        property :url
      end
    end
  end
end