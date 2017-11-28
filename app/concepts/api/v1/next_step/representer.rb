# frozen_string_literal: true

module API::V1
  module NextStep
    module Representer
      class Show < Roar::Decorator
        include Roar::JSON::JSONAPI.resource :next_steps

        attributes do
          property :label, getter: ->(filter) do
            filter[:represented].text_de
          end

          property :text_de
          property :text_en
          property :text_ar
          property :text_fr
          property :text_pl
          property :text_tr
          property :text_ru
          property :text_fa
        end
      end

      class Index < Show
      end

      class Create < Show
      end
    end
  end
end
