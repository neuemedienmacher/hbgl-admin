# frozen_string_literal: true
module API::V1
  module Offer
    module Representer
      class Show < API::V1::Default::Representer::Show
        type :offers

        property :label, getter: ->(offer) do
          offer[:represented].name
        end
        property :name
        property :description
        property :opening_specification
      end
    end
  end
end
