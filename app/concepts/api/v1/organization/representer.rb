# frozen_string_literal: true
module API::V1
  module Organization
    module Representer
      class Show < API::V1::Default::Representer::Show
        type :organizations

        property :label, getter: ->(organization) do
          organization[:represented].name
        end

        property :name
        property :description
        property :offers_count
        property :aasm_state
        property :locations_count

        collection :division_ids
        collection :divisions, decorator: API::V1::Division::Representer::Show,
                               class: Division
      end

      class Index < Show
      end
    end
  end
end
